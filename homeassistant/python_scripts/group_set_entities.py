###
## Original: https://github.com/rodpayne/home-assistant/blob/master/python_scripts/set_state.py
###

groupEntity = data.get('entity_id')
if groupEntity is None:
    logger.error("group_set: missing required argument: entity_id")
else:
    inputStateObject = hass.states.get(groupEntity)
    if inputStateObject is None:
        logger.warning("group_set: unknown group entity_id: {0}".format(groupEntity))
    else:
        logger.debug("group_set: entity_id: {0}".format(groupEntity))
        for item in data:
          if item == 'entity_id':
            logger.debug("group_set: skipping {0}".format(item))
            continue
          elif item == 'entities':
            attr_value = data.get(item)
            logger.debug("group_set: updating group; item: {0}; value: {1}".format(item,attr_value))
            obj = attr_value.split(',')
            if len(obj) > 0:
              logger.debug("group_set: list provided; list: {0}".format(obj))
              uniq=set(obj)
              obj=[]
              for v in sorted(uniq):
                obj.append(v)
              service_data = {"entity_id": groupEntity, "entities": obj}
              logger.info("group_set: calling group set; service_data: {0}: ".format(service_data))
              hass.services.call("group", "set", service_data, False)
            else:
              logger.warning("group_set: group entities did not split: {0}".format(attr_value))
          else:
            logger.warning("group_set: invalid option; item: {0}; value: {1}".format(item,attr_value))
