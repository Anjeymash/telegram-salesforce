
global class Telegram {

    @future(callout=true)
    global static void sendCommentMessage(String messageId, String message, String bot_token, String telegram_id) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.telegram.org/bot' + bot_token + '/sendMessage');
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        req.setBody('{"chat_id" : "' + telegram_id + '", "reply_to_message_id" : "' + messageId + '", "text" : "' + message + '"}');
        Http http = new Http();
        HttpResponse res = http.send(req);
    }


    @future(callout=true)
    global static void sendMessage(String message, String bot_token, String telegram_id) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.telegram.org/bot' + bot_token + '/sendMessage');
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        req.setBody('{"chat_id" : "' + telegram_id + '", "text" : "' + message + '"}');
        Http http = new Http();
        HttpResponse res = http.send(req);
    }

    global static void sendNotification(String message) {
        String bot_token = TelegramBot__c.getOrgDefaults().Token__c;
        List<TelegramCredential__c> users = [
                SELECT
                        TelegramId__c
                FROM TelegramCredential__c
                LIMIT 1
        ];
        for (TelegramCredential__c user : users) {
            sendMessage(message, bot_token, user.TelegramId__c);
        }
    }


    @future(callout=true)
    global static void setPhoto(String userId, Id contactId) {
        String fileId;
        String filePath;
        String botToken = TelegramBot__c.getOrgDefaults().Token__c;

        HttpRequest req1 = new HttpRequest();
        req1.setEndpoint('https://api.telegram.org/bot' + botToken + '/getUserProfilePhotos');
        req1.setMethod('POST');
        req1.setHeader('content-type', 'application/json');
        req1.setBody('{"user_id" : "' + userId + '"}');
        Http http1 = new Http();
        HttpResponse res1 = http1.send(req1);
        System.debug(res1.getBody());

        if (res1.getStatusCode() == 200) {
            TelegramResponse responseData = TelegramResponse.parse(res1.getBody());
            if (!responseData.result.photos.isEmpty()) {
                fileId = responseData.result.photos[0][0].file_id;
            }
        }
        System.debug(fileId);

        if (fileId != null) {
            HttpRequest req2 = new HttpRequest();
            req2.setEndpoint('https://api.telegram.org/bot' + botToken + '/getFile?file_id=' + fileId);
            req2.setMethod('GET');
            Http http2 = new Http();
            HttpResponse res2 = http2.send(req2);
            if (res2.getStatusCode() == 200) {
                TelegramResponse data2 = TelegramResponse.parse(res2.getBody());
                filePath = data2.result.file_path;
            }
        }
        System.debug(filePath);

        if (filePath != null) {
            HttpRequest req3 = new HttpRequest();
            req3.setEndpoint('https://api.telegram.org/file/bot' + botToken + '/' + filePath);
            req3.setMethod('GET');
            Http http3 = new Http();
            HttpResponse res3 = http3.send(req3);
            if (res3.getStatusCode() == 200) {
                Blob txtEft = res3.getBodyAsBlob();
                if (txtEft != null) {
                    Attachment attach = new Attachment();
                    attach.ParentId = contactId;
                    attach.Name = 'UserPhoto';
                    attach.Body = txtEft;
                    System.debug(txtEft);
                    try {
                        insert attach;
                        Contact con = new Contact(id = contactId);
                        con.PhotoId__c = attach.Id;
                        upsert con;
                    } catch (DmlException e) {
                        System.debug(e.getMessage());
                    }

                }
            }
        }
    }

    global static void manageImage(List<Contact> contacts) {
        for (Contact contactItem : contacts) {
            if (contactItem.telegramUserId__c != null && contactItem.PhotoId__c == null) {
                setPhoto(contactItem.telegramUserId__c, contactItem.Id);
            }
        }
    }

}