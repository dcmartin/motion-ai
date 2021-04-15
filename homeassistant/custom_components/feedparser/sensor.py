"""Feedparser sensor"""

import asyncio
import re
import feedparser
import logging
import voluptuous as vol
from datetime import timedelta
from dateutil import parser
from homeassistant.components.sensor import SensorEntity
import homeassistant.helpers.config_validation as cv
from homeassistant.components.sensor import PLATFORM_SCHEMA
from homeassistant.const import CONF_NAME

__version__ = "0.1.2"

REQUIREMENTS = ["feedparser"]

CONF_FEED_URL = "feed_url"
CONF_DATE_FORMAT = "date_format"
CONF_INCLUSIONS = "inclusions"
CONF_EXCLUSIONS = "exclusions"
CONF_SHOW_TOPN = "show_topn"

DEFAULT_SCAN_INTERVAL = timedelta(hours=1)

COMPONENT_REPO = "https://github.com/custom-components/sensor.feedparser/"
SCAN_INTERVAL = timedelta(hours=1)
ICON = "mdi:rss"

PLATFORM_SCHEMA = PLATFORM_SCHEMA.extend(
    {
        vol.Required(CONF_NAME): cv.string,
        vol.Required(CONF_FEED_URL): cv.string,
        vol.Required(CONF_DATE_FORMAT, default="%a, %b %d %I:%M %p"): cv.string,
        vol.Optional(CONF_SHOW_TOPN, default=9999): cv.positive_int,
        vol.Optional(CONF_INCLUSIONS, default=[]): vol.All(cv.ensure_list, [cv.string]),
        vol.Optional(CONF_EXCLUSIONS, default=[]): vol.All(cv.ensure_list, [cv.string]),
    }
)

_LOGGER = logging.getLogger(__name__)

@asyncio.coroutine
def async_setup_platform(hass, config, async_add_devices, discovery_info=None):
    async_add_devices(
        [
            FeedParserSensor(
                feed=config[CONF_FEED_URL],
                name=config[CONF_NAME],
                date_format=config[CONF_DATE_FORMAT],
                show_topn=config[CONF_SHOW_TOPN],
                inclusions=config[CONF_INCLUSIONS],
                exclusions=config[CONF_EXCLUSIONS],
            )
        ],
        True,
    )


class FeedParserSensor(SensorEntity):
    def __init__(
        self,
        feed: str,
        name: str,
        date_format: str,
        show_topn: str,
        exclusions: str,
        inclusions: str,
    ):
        self._feed = feed
        self._name = name
        self._date_format = date_format
        self._show_topn = show_topn
        self._inclusions = inclusions
        self._exclusions = exclusions
        self._state = None
        self._entries = []

    def update(self):
        parsedFeed = feedparser.parse(self._feed)

        if not parsedFeed:
            _LOGGER.warn("Feed %s not parsed; URL: %s", self._name, self._feed)
            return False
        else:
            _LOGGER.debug("Updating feed: %s; URL: %s", self._name, self._feed)
            self._state = (
                self._show_topn
                if len(parsedFeed.entries) > self._show_topn
                else len(parsedFeed.entries)
            )
            self._entries = []

            for entry in parsedFeed.entries[: self._state]:
                entryValue = {}

                for key, value in entry.items():
                    if (
                        (self._inclusions and key not in self._inclusions)
                        or ("parsed" in key)
                        or (key in self._exclusions)
                    ):
                        continue
                    if key in ["published", "updated", "created", "expired"]:
                        value = parser.parse(value).strftime(self._date_format)

                    entryValue[key] = value

                if "image" in self._inclusions and "image" not in entryValue.keys():
                    images = []
                    if "summary" in entry.keys():
                        images = re.findall(
                            r"<img.+?src=\"(.+?)\".+?>", entry["summary"]
                        )
                    if images:
                        entryValue["image"] = images[0]
                    else:
                        entryValue[
                            "image"
                        ] = "https://www.home-assistant.io/images/favicon-192x192-full.png"

                self._entries.append(entryValue)

    @property
    def name(self):
        return self._name

    @property
    def state(self):
        return self._state

    @property
    def icon(self):
        return ICON

    @property
    def device_state_attributes(self):
        return {"entries": self._entries}
