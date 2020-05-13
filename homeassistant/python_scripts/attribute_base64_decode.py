###
## homeassistant/python_scripts/attribute_base64_decode.py
###

entityID = data.get('entity_id')
if entityID is None:
  logger.error("set_state: missing required argument: entity_id")
else:
  entityObject = hass.states.get(entityID)
  if entityObject is None:
    logger.warning("set_state: unknown entity_id: {0}".format(entityID))
  else:
    fileOutput = None
    obj = None

    logger.debug("set_state: entity_id: {0}".format(entityID))
    for item in data:
      if item == 'entity_id':
        logger.debug("set_state: skipping {0}".format(item))
        continue
      elif item == 'filename' and fileOutput is None:
        attr_value = data.get(item)
        logger.debug("attribute_base64_decode: writing file: {0}".format(attr_value))
        fileOutput = open(attr_value, "w")
      elif item == 'attribute' and obj is None:
        attr_value = data.get(item)
        logger.debug("attribute_base64_decode: decoding entity attribute: {0}".format(attr_value))
        obj = base64.b64decode(attr_value)
      else:
        logger.warning("attribute_base64_decode: invalid/duplicate option; item: {0}; value: {1}".format(item,attr_value))
      
    if obj is not None and fileOutput is not None:
      logger.debug("attribute_base64_decode: writing to file")
      fileOutput.write(obj)
      fileOutput.close()
    else:
      logger.debug("attribute_base64_decode: options did not split: {0}".format(attr_value))
