###
## Original: https://github.com/rodpayne/home-assistant/blob/master/python_scripts/set_state.py
###

#--------------------------------------------------------------------------------------------------
# Set the state or other attributes for the specified entity.
# Updates from @xannor so that a new entity can be created if it does not exist.
#--------------------------------------------------------------------------------------------------


inputEntity = data.get('entity_id')
if inputEntity is None:
    logger.error("set_state: missing required argument: entity_id")
else:
    inputStateObject = hass.states.get(inputEntity)
    if inputStateObject is None and not data.get('allow_create'):
        logger.warning("set_state: unknown entity_id: {0}; allow_create is not set".format(inputEntity))
    else:
        logger.debug("set_state: entity_id: {0}".format(inputEntity))
        if not inputStateObject is None:
          inputState = inputStateObject.state
          inputAttributesObject = inputStateObject.attributes.copy()
        else:
          inputState = 'unknown'
          inputAttributesObject = {}
    
        # process entity attribute value updates 
        for item in data:

            # excluding 'entity_id', 'allow_create'
            if item == 'entity_id':
              logger.debug("set_state: skipping {0}".format(item))
              continue
            elif item == 'allow_create':
              logger.debug("set_state: skipping {0}".format(item))
              continue

            if item == 'state':
              # state can only be string
              inputState = data.get(item)
              logger.debug("set_state: updating entity state; item: {0}; value: {1}".format(item,inputState))
            elif item == 'entity_ids':
              attr_value = data.get(item)
              logger.debug("set_state: updating entity attribute value; item: {0}; value: {1}".format(item,attr_value))
              inputAttributesObject['entity_id'] = attr_value
            else:
              attr_value = data.get(item)
              logger.debug("set_state: updating entity attribute value; item: {0}; value: {1}".format(item,attr_value))
              inputAttributesObject[item] = attr_value

        # update
        logger.debug("set_state: updating; entity: {0} to {1}".format(inputEntity,inputAttributesObject))
        logger.info("set_state: updating; entity: {0}".format(inputEntity))
        hass.states.set(inputEntity, inputState, inputAttributesObject)
