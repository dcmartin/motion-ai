import logging
import voluptuous as vol

from homeassistant import config_entries
from homeassistant.core import callback

_LOGGER = logging.getLogger(__name__)

@config_entries.HANDLERS.register("favicon")
class ConfigFlow(config_entries.ConfigFlow):
    async def async_step_user(self, user_input=None):
        if self._async_current_entries():
            return self.async_abort(reason="single_instance_allowed")
        return await self.async_step_config()

    async def async_step_config(self, user_input=None):
        if user_input is not None:
            return self.async_create_entry(
                    title="", data=user_input)

        return self.async_show_form(
            step_id='config',
            data_schema=vol.Schema(
                {
                    vol.Optional('title'): str,
                    vol.Optional('icon_path'): str,
                }
            ),
        )

    @staticmethod
    @callback
    def async_get_options_flow(config_entry):
        return EditFlow(config_entry)

class EditFlow(config_entries.OptionsFlow):

    def __init__(self, config_entry):
        self.config_entry = config_entry

    async def async_step_init(self, user_input=None):
        if user_input is not None:
            _LOGGER.error(user_input)
            return self.async_create_entry(title="", data=user_input)
        return self.async_show_form(
            step_id='init',
            data_schema=vol.Schema(
                {
                    vol.Optional('title',
                        description="test",
                        default=self.config_entry.options.get("title", "")): str,
                    vol.Optional('icon_path',
                        default=self.config_entry.options.get("icon_path", "")): str,
                }
            ),
        )

