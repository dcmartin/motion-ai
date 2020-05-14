###
## Original: https://github.com/rodpayne/home-assistant/blob/master/python_scripts/set_state.py
###

inputEntity = data.get('entity_id')
if inputEntity is None:
    logger.error("set_state: missing required argument: entity_id")
else:
    inputStateObject = hass.states.get(inputEntity)
    if inputStateObject is None:
        logger.warning("set_state: unknown entity_id: {0}".format(inputEntity))
    else:
        logger.debug("set_state: entity_id: {0}".format(inputEntity))
        for item in data:
          if item == 'entity_id':
            logger.debug("set_state: skipping {0}".format(item))
            continue
          elif item == 'options':
            attr_value = data.get(item)
            logger.debug("set_state: updating entity attribute array; item: {0}; value: {1}".format(item,attr_value))
            obj = attr_value.split(',')
            if len(obj) > 0:
              logger.debug("set_state: list provided; list: {0}".format(obj))
              obj.remove('latest')
              ncamera=len(obj)
              uniq=set(obj)
              d=ncamera - len(uniq)
              if d > 0:
                logger.info("set_state: {0} duplicates; result: {1}".format(d,uniq))
              obj=['latest']
              for v in sorted(uniq):
                obj.append(v)
              service_data = {"entity_id": inputEntity, "options": obj}
              logger.info("set_state: calling input_select/set_options; service_data: {0}: ".format(service_data))
              hass.services.call("input_select", "set_options", service_data, False)
            else:
              logger.warning("set_state: options did not split: {0}".format(attr_value))
          else:
            logger.warning("set_state: invalid option; item: {0}; value: {1}".format(item,attr_value))
