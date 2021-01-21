###
## Original: https://github.com/rodpayne/home-assistant/blob/master/python_scripts/twilio_sms.py
###

action = 'twilio_sms'
targets=[]
sms_data=[]

v = data.get('name')
if v is None:
  logger.error("twilio_sms: missing required argument: name")

v = data.get('message')
if v is None:
    logger.error("twilio_sms: missing required argument: message")

v = data.get('targets')
if v is None:
    logger.error("twilio_sms: missing required argument: message")

for item in data:
   v = data.get(item)
   logger.debug("twilio_sms: item: {0}; value: {1}".format(item,v))

   if item == 'message':
     continue
   elif item == 'data':
     sms_data = v
     continue
   elif item == 'targets':
     t = v.split(',')
     if len(t) > 0:
       uniq=set(t)
       for v in sorted(uniq):
         if len(v) > 0:
           targets.append(v)
     else:
       logger.warning("twilio_sms: targets did not split: {0}".format(v))
   else:
     logger.error("twilio_sms: invalid option; item: {0}; value: {1}".format(item,v))

if len(targets) > 0:
  service_data = {"message": message, "data": sms_data, "target": targets}
  logger.info("twilio_sms: calling action: {0}; service_data: {1}: ".format(action,service_data))
  hass.services.call("notify",action,service_data,False)
else:
  logger.info("twilio_sms: no targets")
