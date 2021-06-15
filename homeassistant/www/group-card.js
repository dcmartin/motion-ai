class GroupCard extends HTMLElement {

  setConfig(config) {
    if (!config.group) {
      throw new Error('Please specify a group');
    }

    if (this.lastChild) this.removeChild(this.lastChild);
    const cardConfig = Object.assign({}, config);
    if (!cardConfig.card) cardConfig.card = {};
    if (!cardConfig.card.type) cardConfig.card.type = 'entities';
    if (!cardConfig.entities_vars) cardConfig.entities_vars = {type: 'entity'};
    const element = document.createElement(`hui-${cardConfig.card.type}-card`);
    this.appendChild(element);
    this._config = JSON.parse(JSON.stringify(cardConfig));
  }

  set hass(hass) {
    const config = this._config;
    if (!hass.states[config.group]){
      throw new Error(`${config.group} not found`);
    }
    const attr = hass.states[config.group].attributes['entity_id'];
    if (typeof attr === 'string') {
      const entities = JSON.parse(attr);
    } else {
      const entities = attr;
    }
    if (!config.card.entities || config.card.entities.length !== entities.length ||
      !config.card.entities.every((value, index) => value.entity === entities[index].entity)) {
      if (!config.row) {
        config.card.entities = entities;
      }
      else {
        const fmtentities = [];
        entities.forEach (function (item) {
          const stateObj = new Object;
          for (var k in config.row)
            stateObj[k]=config.row[k];
          stateObj.entity = item;
          fmtentities.push (stateObj);
        });
        config.card.entities = fmtentities;
      }
      if (config.card.type == "entities" || config.card.type == "glance") {
        config.card.entities = entities;
      } else {
        config.card.cards = []
        for(const entity of entities){
          const card = JSON.parse(JSON.stringify(config.entities_vars));
          card.entity = entity
          config.card.cards.push(card)
        }
      }
    }
    this.lastChild.setConfig(config.card);
    this.lastChild.hass = hass;
  }

  getCardSize() {
    return 'getCardSize' in this.lastChild ? this.lastChild.getCardSize() : 1;
  }
}

customElements.define('group-card', GroupCard);

