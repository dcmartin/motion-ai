import logging
import os
import re
from collections import defaultdict

import homeassistant.components.frontend
from homeassistant.components.frontend import _frontend_root

_LOGGER = logging.getLogger(__name__)

DOMAIN = "favicon"

RE_APPLE = "^favicon-apple-"
RE_ICON = "^favicon-(\d+x\d+)\..+"

CONFIG_TITLE = "title"
CONFIG_ICON_PATH = "icon_path"

async def async_setup(hass, config):
    if not hass.data.get(DOMAIN):
        hass.data[DOMAIN] = defaultdict(int)

    if not hass.data[DOMAIN].get("get_template"):
        hass.data[DOMAIN]["get_template"] = homeassistant.components.frontend.IndexView.get_template
    if not hass.data[DOMAIN].get("manifest_icons"):
        hass.data[DOMAIN]["manifest_icons"] = homeassistant.components.frontend.MANIFEST_JSON["icons"].copy()

    conf = config.get(DOMAIN)
    if not conf:
        return True
    if CONFIG_ICON_PATH in hass.data[DOMAIN]:
        del hass.data[DOMAIN][CONFIG_ICON_PATH]
    if CONFIG_TITLE in hass.data[DOMAIN]:
        del hass.data[DOMAIN][CONFIG_TITLE]
    hass.data[DOMAIN].update(conf)
    return await apply_hooks(hass)

async def async_setup_entry(hass, config_entry):
    config_entry.add_update_listener(_update_listener)
    if not config_entry.options:
        config_entry.options = config_entry.data
    return await _update_listener(hass, config_entry)

async def async_remove_entry(hass, config_entry):
    return remove_hooks(hass)

async def _update_listener(hass, config_entry):
    conf = config_entry.options
    if CONFIG_ICON_PATH in hass.data[DOMAIN]:
        del hass.data[DOMAIN][CONFIG_ICON_PATH]
    if CONFIG_TITLE in hass.data[DOMAIN]:
        del hass.data[DOMAIN][CONFIG_TITLE]
    hass.data[DOMAIN].update(conf)
    return await apply_hooks(hass)


def find_icons(hass, path):

    icons = {}
    manifest = []
    if not path or not path.startswith("/local/"):
        return icons

    localpath = "www" + path[len("/local"):]
    localpath = hass.config.path(localpath)
    _LOGGER.info("Looking for icons in: %s", localpath)
    try:
        for fn in os.listdir(localpath):
            if fn == "favicon.ico":
                icons["favicon"] = os.path.join(path, fn)
                _LOGGER.info("Found favicon: %s", os.path.join(path, fn))
            apple = re.search(RE_APPLE, fn)
            if apple:
                icons["apple"] = os.path.join(path, fn)
                _LOGGER.info("Found apple icon: %s", os.path.join(path, fn))
            icon = re.search(RE_ICON, fn)
            if icon:
                manifest.append({
                    "src": os.path.join(path, fn),
                    "sizes": icon.group(1),
                    "type": "image/png",
                    })
                _LOGGER.info("Found icon: %s", os.path.join(path, fn))
    except:
        pass

    if manifest:
        icons["manifest"] = manifest
    return icons

async def apply_hooks(hass):
    data = hass.data.get(DOMAIN, {})
    icons = await hass.loop.run_in_executor(None, find_icons, hass, data.get(CONFIG_ICON_PATH, None))
    title = data.get(CONFIG_TITLE, None)

    def _get_template(self):
        tpl = data["get_template"](self)
        render = tpl.render

        def new_render(*args, **kwargs):
            text = render(*args, **kwargs)
            if "favicon" in icons:
                text = text.replace("/static/icons/favicon.ico", icons["favicon"])
            if "apple" in icons:
                text = text.replace("/static/icons/favicon-apple-180x180.png", icons["apple"])
            if title:
                text = text.replace("<title>Home Assistant</title>", f"<title>{title}</title>")
                text = text.replace("<body>", f"""<body>
                    <script type="module">
                        customElements.whenDefined('ha-sidebar').then(() => {{
                            const Sidebar = customElements.get('ha-sidebar');
                            const render = Sidebar.prototype.render;
                            Sidebar.prototype.render = function() {{
                                const retval = render.bind(this)();
                                retval.values.forEach((val, i, arr) => {{
                                    if (val === "Home Assistant")
                                        retval.values[i] = "{title}";
                                }});
                                return retval;
                            }}
                        }});

                        window.setInterval(() => {{
                            if(!document.title.endsWith("- {title}") && document.title !== "{title}") {{
                                document.title = document.title.replace(/Home Assistant/, "{title}");
                            }}
                        }}, 1000);
                    </script>
                """)

            return text

        tpl.render = new_render
        return tpl

    if title or "favicon" in icons or "apple" in icons:
        homeassistant.components.frontend.IndexView.get_template = _get_template
        for view in hass.http.app.router.resources():
            if isinstance(view, homeassistant.components.frontend.IndexView):
                view._template_cache = None

    homeassistant.components.frontend.MANIFEST_JSON["icons"] = data["manifest_icons"].copy()
    if "manifest" in icons:
        homeassistant.components.frontend.MANIFEST_JSON["icons"] = icons["manifest"]

    homeassistant.components.frontend.MANIFEST_JSON["name"] = "Home Assistant"
    homeassistant.components.frontend.MANIFEST_JSON["short_name"] = "Assistant"
    if title:
        homeassistant.components.frontend.MANIFEST_JSON["name"] = title
        homeassistant.components.frontend.MANIFEST_JSON["short_name"] = title

    return True

def remove_hooks(hass):
    data = hass.data[DOMAIN]
    homeassistant.components.frontend.IndexView.get_template = data["get_template"]
    homeassistant.components.frontend.MANIFEST_JSON["icons"] = data["manifest_icons"].copy()
    homeassistant.components.frontend.MANIFEST_JSON["name"] = "Home Assistant"
    homeassistant.components.frontend.MANIFEST_JSON["short_name"] = "Assistant"
    return True

