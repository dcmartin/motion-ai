###
## Original: https://github.com/rodpayne/home-assistant/blob/master/python_scripts/switch_act_multiple.py
###

action = 'toggle'
inputEntity = data.get('entities')
if inputEntity is None:
    logger.error("switch_act_multiple: missing required argument: entities")
else:
    logger.debug("switch_act_multiple: entities: {0}".format(inputEntity))
    for item in data:
      if item == 'action':
        action = data.get(item)
        continue
      elif item == 'entities':
        attr_value = data.get(item)
        logger.debug("switch_act_multiple: updating entity attribute array; item: {0}; value: {1}".format(item,attr_value))
        obj = attr_value.split(',')
        if len(obj) > 0:
          logger.debug("switch_act_multiple: list provided; list: {0}".format(obj))
          nentity=len(obj)
          uniq=set(obj)
          d=nentity - len(uniq)
          if d > 0:
            logger.info("switch_act_multiple: {0} duplicates; result: {1}".format(d,uniq))
          obj=[]
          for v in sorted(uniq):
            if len(v) > 0:
              obj.append(v)
          for inputEntity in obj:
            inputStateObject = hass.states.get(inputEntity)
            if inputStateObject is None:
                logger.warning("switch_act_multiple: unknown entity_id: {0}".format(inputEntity))
            else:
              service_data = {"entity_id": inputEntity}
              logger.info("switch_act_multiple: calling action: {0}; service_data: {1}: ".format(action,service_data))
              hass.services.call("switch",action,service_data,False)
        else:
          logger.warning("switch_act_multiple: options did not split: {0}".format(attr_value))
      else:
        logger.warning("switch_act_multiple: invalid option; item: {0}; value: {1}".format(item,attr_value))



