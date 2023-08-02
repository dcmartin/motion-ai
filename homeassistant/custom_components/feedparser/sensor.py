"""Feedparser sensor."""
from __future__ import annotations

import email.utils
import logging
from datetime import datetime, timedelta, timezone
from typing import TYPE_CHECKING

import feedparser  # type: ignore[import]
import homeassistant.helpers.config_validation as cv
import voluptuous as vol
from dateutil import parser
from feedparser import FeedParserDict
from homeassistant.components.sensor import PLATFORM_SCHEMA, SensorEntity
from homeassistant.const import CONF_NAME, CONF_SCAN_INTERVAL
from homeassistant.util import dt
from homeassistant.helpers import config_validation as cv, template

if TYPE_CHECKING:
    from homeassistant.core import HomeAssistant
    from homeassistant.helpers.entity_platform import AddEntitiesCallback
    from homeassistant.helpers.typing import ConfigType, DiscoveryInfoType

__version__ = "0.1.11"

COMPONENT_REPO = "https://github.com/custom-components/feedparser/"

REQUIREMENTS = ["feedparser"]

CONF_FEED_URL = "feed_url"
CONF_DATE_FORMAT = "date_format"
CONF_LOCAL_TIME = "local_time"
CONF_INCLUSIONS = "inclusions"
CONF_EXCLUSIONS = "exclusions"
CONF_SHOW_TOPN = "show_topn"

DEFAULT_DATE_FORMAT = "%a, %b %d %I:%M %p"
DEFAULT_SCAN_INTERVAL = timedelta(hours=1)
DEFAULT_THUMBNAIL = "https://www.home-assistant.io/images/favicon-192x192-full.png"
DEFAULT_TOPN = 9999

PLATFORM_SCHEMA = PLATFORM_SCHEMA.extend(
    {
        vol.Required(CONF_NAME): cv.string,
        vol.Required(CONF_FEED_URL): cv.template,
        vol.Required(CONF_DATE_FORMAT, default=DEFAULT_DATE_FORMAT): cv.string,
        vol.Optional(CONF_LOCAL_TIME, default=False): cv.boolean,
        vol.Optional(CONF_SHOW_TOPN, default=DEFAULT_TOPN): cv.positive_int,
        vol.Optional(CONF_INCLUSIONS, default=[]): vol.All(cv.ensure_list, [cv.string]),
        vol.Optional(CONF_EXCLUSIONS, default=[]): vol.All(cv.ensure_list, [cv.string]),
        vol.Optional(CONF_SCAN_INTERVAL, default=DEFAULT_SCAN_INTERVAL): cv.time_period,
    },
)

_LOGGER = logging.getLogger(__name__)


async def async_setup_platform(
    hass: HomeAssistant,
    config: ConfigType,
    async_add_devices: AddEntitiesCallback,
    discovery_info: DiscoveryInfoType | None = None,
) -> None:
    """Set up the Feedparser sensor."""
    feed_url=config[CONF_FEED_URL]

    if isinstance(feed_url, template.Template):
        _LOGGER.debug("Feed is template: %s", feed_url)
        template.attach(hass, feed_url)

    async_add_devices(
        [
            FeedParserSensor(
                feed=feed_url,
                name=config[CONF_NAME],
                date_format=config[CONF_DATE_FORMAT],
                show_topn=config[CONF_SHOW_TOPN],
                inclusions=config[CONF_INCLUSIONS],
                exclusions=config[CONF_EXCLUSIONS],
                scan_interval=config[CONF_SCAN_INTERVAL],
                local_time=config[CONF_LOCAL_TIME],
            ),
        ],
        update_before_add=True,
    )


class FeedParserSensor(SensorEntity):
    """Representation of a Feedparser sensor."""

    def __init__(
        self: FeedParserSensor,
        feed: str,
        name: str,
        date_format: str,
        show_topn: int,
        exclusions: list[str | None],
        inclusions: list[str | None],
        scan_interval: timedelta,
        local_time: bool,
    ) -> None:
        self._feed = feed
        self._attr_name = name
        self._attr_icon = "mdi:rss"
        self._date_format = date_format
        self._show_topn: int = show_topn
        self._inclusions = inclusions
        self._exclusions = exclusions
        self._scan_interval = scan_interval
        self._local_time = local_time
        self._entries: list[dict[str, str]] = []
        self._attr_extra_state_attributes = {"entries": self._entries}

    def update(self: FeedParserSensor) -> None:
        """Parse the feed and update the state of the sensor."""
        if isinstance(self._feed, template.Template):
            _LOGGER.debug("Evaluating feed template: %s", self._feed)
            tmp = self._feed.async_render(None, limited=False, parse_result=False)
            if tmp in ['unknown','none','unavailable','null']:
                _LOGGER.warn("Template failure: %s; template: %s", tmp, self._feed)
                return False
            else:
                _LOGGER.debug("Feed URL: %s from template: %s", tmp, self._feed)
            feed_url = tmp
        else:
            feed_url = self._feed

        parsed_feed: FeedParserDict = feedparser.parse(feed_url)

        if not parsed_feed:
            self._attr_native_value = None
            return

        self._attr_native_value = (
            self._show_topn
            if len(parsed_feed.entries) > self._show_topn
            else len(parsed_feed.entries)
        )
        self._entries.extend(self._generate_entries(parsed_feed))

    def _generate_entries(
        self: FeedParserSensor, parsed_feed: FeedParserDict
    ) -> list[dict[str, str]]:
        return [
            self._generate_sensor_entry(feed_entry)
            for feed_entry in parsed_feed.entries[
                : self.native_value  # type: ignore[misc]
            ]
        ]

    def _generate_sensor_entry(
        self: FeedParserSensor, feed_entry: FeedParserDict
    ) -> dict[str, str]:
        sensor_entry = {}
        for key, value in feed_entry.items():
            if (
                (self._inclusions and key not in self._inclusions)
                or ("parsed" in key)
                or (key in self._exclusions)
            ):
                continue
            if key in ["published", "updated", "created", "expired"]:
                parsed_date: datetime = self._parse_date(value)
                sensor_entry[key] = parsed_date.strftime(self._date_format)
            else:
                sensor_entry[key] = value

            self._process_image(feed_entry, sensor_entry)

        return sensor_entry

    def _parse_date(self: FeedParserSensor, date: str) -> datetime:
        try:
            parsed_time: datetime = email.utils.parsedate_to_datetime(date)
        except ValueError:
            _LOGGER.warning(
                (
                    "Unable to parse RFC-822 date from %s. "
                    "This could be caused by incorrect pubDate format "
                    "in the RSS feed or due to a leapp second"
                ),
                date,
            )
            parsed_time = parser.parse(date)
            if not parsed_time.tzname():
                # replace tzinfo with UTC offset if tzinfo does not contain a TZ name
                parsed_time = parsed_time.replace(
                    tzinfo=timezone(parsed_time.utcoffset())  # type: ignore[arg-type]
                )
        if self._local_time:
            parsed_time = dt.as_local(parsed_time)
        return parsed_time

    def _process_image(
        self: FeedParserSensor, feed_entry: FeedParserDict, sensor_entry: dict[str, str]
    ) -> None:
        if "image" in self._inclusions and "image" not in sensor_entry.keys():
            if "enclosures" in feed_entry:
                images = [
                    enc
                    for enc in feed_entry["enclosures"]
                    if enc.type.startswith("image/")
                ]
            else:
                images = []
            if images:
                sensor_entry["image"] = images[0]["href"]  # pick the first image found
            else:
                sensor_entry[
                    "image"
                ] = DEFAULT_THUMBNAIL  # use default image if no image found

    @property
    def extra_state_attributes(self: FeedParserSensor) -> dict[str, list]:
        """Return entity specific state attributes."""
        return {"entries": self._entries}
