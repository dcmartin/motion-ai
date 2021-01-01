###
## Original: https://github.com/rodpayne/home-assistant/blob/master/python_scripts/input_select_set_options.py
###

inputEntity = data.get('entity_id')
if inputEntity is None:
    logger.error("input_select_set_options: missing required argument: entity_id")
else:
    inputStateObject = hass.states.get(inputEntity)
    if inputStateObject is None:
        logger.warning("input_select_set_options: unknown entity_id: {0}".format(inputEntity))
    else:
        logger.debug("input_select_set_options: entity_id: {0}".format(inputEntity))
        df='latest'
        for item in data:
          if item == 'entity_id':
            logger.debug("input_select_set_options: skipping {0}".format(item))
            continue
          if item == 'default':
            df = data.get(item)
            logger.debug("input_select_set_options: skipping {0}".format(item))
            continue
          elif item == 'options':
            attr_value = data.get(item)
            logger.debug("input_select_set_options: updating entity attribute array; item: {0}; value: {1}".format(item,attr_value))
            obj = attr_value.split(',')
            if len(obj) > 0:
              logger.debug("input_select_set_options: list provided; list: {0}".format(obj))
              if df in obj:
                obj.remove(df)
              ncamera=len(obj)
              uniq=set(obj)
              d=ncamera - len(uniq)
              if d > 0:
                logger.info("input_select_set_options: {0} duplicates; result: {1}".format(d,uniq))
              obj=[df]
              for v in sorted(uniq):
                if len(v) > 0:
                  obj.append(v)
              service_data = {"entity_id": inputEntity, "options": obj}
              logger.info("input_select_set_options: calling input_select/set_options; service_data: {0}: ".format(service_data))
              hass.services.call("input_select","set_options",service_data,False)
            else:
              logger.warning("input_select_set_options: options did not split: {0}".format(attr_value))
          else:
            logger.warning("input_select_set_options: invalid option; item: {0}; value: {1}".format(item,attr_value))
