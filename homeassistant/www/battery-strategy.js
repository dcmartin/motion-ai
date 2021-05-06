/*
Battery strategy that shows your battery entities grouped by area.

To use:
 - store this file in `<config>/www/battery-strategy.js`
 - Add lovelace resource: `/local/battery-strategy.js`, type JavaScript Module
 - Create a new Lovelace dashboard and set as content:

views:
- title: Batteries
  strategy:
    type: 'custom:battery-strategy'
    // Optional options. Will be merged into the grid/sensor configs.
    options:
      gridOptions:
        columns: 3
      sensorOptions:
        graph: none
*/

const stateObj2Card = (stateObj, strategyOptions, groupName) => {
  const card = {
    type: "sensor",
    entity: stateObj.entity_id,
    graph: "line",
    ...strategyOptions.sensorOptions,
  };

  // If we have a group name, remove it from the entity name
  // Example: In group Bedroom, changes Bedroom Lights -> Lights
  if (groupName) {
    const entityName = stateObj.attributes.friendly_name;

    if (entityName && entityName.startsWith(`${groupName} `)) {
      card.name = entityName.substr(groupName.length + 1);
    }
  }

  return card;
};

const createGridCard = (title, cards, strategyOptions) => ({
  type: "grid",
  columns: 2,
  title,
  cards,
  ...strategyOptions.gridOptions,
});

class BatteryStrategy {
  /*
      info: {
        view: LovelaceViewConfig;
        config: LovelaceConfig;
        hass: HomeAssistant;
        narrow: boolean | undefined;
      }
    */
  static async generateView(info) {
    const strategyOptions = info.view.strategy.options || {};
    const [areas, devices, entities] = await Promise.all([
      info.hass.callWS({ type: "config/area_registry/list" }),
      info.hass.callWS({ type: "config/device_registry/list" }),
      info.hass.callWS({ type: "config/entity_registry/list" }),
    ]);

    const entityLookup = Object.fromEntries(
      entities.map((ent) => [ent.entity_id, ent])
    );
    const deviceLookup = Object.fromEntries(
      devices.map((dev) => [dev.id, dev])
    );

    // Find all battery sensors
    let states = Object.values(info.hass.states).filter(
      (stateObj) =>
        stateObj.entity_id.startsWith("sensor.") &&
        stateObj.attributes.device_class == "battery"
    );

    const gridCards = [];

    for (const area of areas) {
      const processed = new Set();
      const areaEntities = [];

      for (const stateObj of states) {
        const entry = entityLookup[stateObj.entity_id];

        if (!entry) {
          continue;
        }

        if (entry.area_id) {
          if (entry.area_id !== area.area_id) {
            continue;
          }
        } else if (entry.device_id) {
          const device = deviceLookup[entry.device_id];
          if (!device || device.area_id !== area.area_id) {
            continue;
          }
        } else {
          continue;
        }

        areaEntities.push(stateObj);
        processed.add(stateObj);
      }

      if (areaEntities.length > 0) {
        gridCards.push(
          createGridCard(
            area.name,
            areaEntities.map((stateObj) =>
              stateObj2Card(stateObj, strategyOptions, area.name)
            ),
            strategyOptions
          )
        );
      }

      states = states.filter((stateObj) => !processed.has(stateObj));
      if (states.length === 0) break;
    }

    // Entities without state
    if (states.length > 0) {
      gridCards.push(
        createGridCard(
          "No Area",
          states.map((stateObj) => stateObj2Card(stateObj, strategyOptions)),
          strategyOptions
        )
      );
    }

    return {
      cards: gridCards,
    };
  }
}

customElements.define("battery-strategy", BatteryStrategy);

