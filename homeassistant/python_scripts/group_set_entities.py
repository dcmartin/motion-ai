###
## Original: https://github.com/rodpayne/home-assistant/blob/master/python_scripts/group_set_entities.py
###

inputEntity = data.get('entity_id')
if inputEntity is None:
    logger.error("group_set_entities: missing required argument: entity_id")
else:
    inputStateObject = hass.states.get(inputEntity)
    if inputStateObject is None:
        logger.warning("group_set_entities: unknown entity_id: {0}".format(inputEntity))
    else:
        logger.debug("group_set_entities: entity_id: {0}".format(inputStateObject))
        objectID=inputStateObject.object_id
        for item in data:
          if item == 'entity_id':
            logger.debug("group_set_entities: skipping {0}".format(item))
            continue
          elif item == 'entities':
            attr_value = data.get(item)
            logger.debug("group_set_entities: updating entity attribute array; item: {0}; value: {1}".format(item,attr_value))
            obj = attr_value.split(',')
            if len(obj) > 0:
              logger.debug("group_set_entities: list provided; list: {0}".format(obj))
              ncamera=len(obj)
              uniq=set(obj)
              d=ncamera - len(uniq)
              if d > 0:
                logger.info("group_set_entities: {0} duplicates; result: {1}".format(d,uniq))
              obj=[]
              for v in sorted(uniq):
                if len(v) > 0:
                  obj.append(v)
              service_data = {"object_id": objectID, "entities": obj}
              logger.info("group_set_entities: calling input_select/set_options; service_data: {0}: ".format(service_data))
              hass.services.call("group","set",service_data,False)
            else:
              logger.warning("group_set_entities: options did not split: {0}".format(attr_value))
          else:
            logger.warning("group_set_entities: invalid option; item: {0}; value: {1}".format(item,attr_value))
