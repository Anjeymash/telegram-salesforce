@RestResource(urlMapping='/bot/message')
global with sharing class TelegramWebHookService {
    @HttpPost
    global static void publishEvent() {
        RestRequest req = RestContext.request;
        Blob body = req.requestBody;
    //    TelegramWebhookResponseData parsedData = TelegramWebhookResponseData.parse(body.toString());
      //  Telegram.sendMessage('Hi,  ' + parsedData.Message.From_Z.first_name + '! Agent will contact you as soon as possible.', TelegramBot__c.getOrgDefaults().Token__c,
      //          parsedData.Message.chat.chat_id);
        /*  if(parsedData.Message.text_Z.contains('/news')){
              Telegram.sendNotification('Hi,  ' + parsedData.Message.From_Z.first_name + '! Agent will contact you as soon as possible.');
          }*/
        List<TelegramNotification__e> events = new List<TelegramNotification__e>();
        events.add(new TelegramNotification__e(Message__c = body.toString()));
        EventBus.publish(events);

    }


}