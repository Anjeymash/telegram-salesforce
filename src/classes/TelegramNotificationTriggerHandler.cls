
public with sharing class TelegramNotificationTriggerHandler {
    private static final String token = TelegramBot__c.getOrgDefaults().Token__c;
    private static final String tagTrash = '<[^>]+>';
    public static void manageNotification(List<TelegramNotification__e> events) {
        List<Contact> contacts = new List<Contact>();
      //  List <Case> cases = new List <Case>();
        Map <String, FeedItem> feeds = new Map <String, FeedItem>();
        for (TelegramNotification__e eventItem : events) {
            TelegramWebHookResponseData parsedData = TelegramWebHookResponseData.parse(eventItem.Message__c);
           /* cases.add(new Case (
                    description = eventItem.Message__c,
                    subject = parsedData.Message.From_Z.first_name + ' ' + parsedData.Message.text_Z));*/

            Contact contactItem = new Contact(
                    TelegramUserId__c = parsedData.Message.chat.chat_id
            );
            if (parsedData.Message.chat.title == null) {
                contactItem.FirstName = parsedData.Message.from_Z.first_name;
                contactItem.LastName = parsedData.Message.from_Z.last_name;
            } else {
                contactItem.LastName = parsedData.Message.chat.title;
            }

            contacts.add (contactItem);
            feeds.put(contactItem.TelegramUserId__c, new FeedItem(
                    Title = parsedData.Message.message_id,
                    Body = 'From ' + parsedData.Message.From_Z.username + ': ' + parsedData.Message.text_Z));

            Telegram.sendCommentMessage(
                    parsedData.Message.message_id, 'Hi,  ' + parsedData.Message.From_Z.first_name + '! Agent will contact you as soon as possible.',
                    token,
                    parsedData.Message.chat.chat_id);
        }
        upsert contacts TelegramUserId__c;
        for (Contact contactItem : contacts) {
            feeds.get(contactItem.TelegramUserId__c).parentId = contactItem.Id;
        }
        insert feeds.values();
       // insert cases;
    }

    public static void manageFeedItems(List<FeedItem> feedItems) {
        User processUser = [
                SELECT id
                from User
                WHERE Name = 'Automated Process'
        ];

        List <Id> contactIds = new List <Id>();
        for (FeedItem feedItem : feedItems) {
            if (feedItem.createdById != processUser.Id) {
                contactIds.add(feedItem.parentId);
            }
        }
        Map<Id, Contact> contactMap = new Map <Id, Contact>([
                SELECT TelegramUserId__c
                FROM Contact
                WHERE id IN:contactIds
                AND TelegramUserId__c != null
        ]);

        if (!contactMap.isEmpty()) {
            for (FeedItem feedItem : feedItems) {
                if ((feedItem.ParentId != null) && (feedItem.ParentId.getSobjectType().getDescribe().label == 'Contact')) {
                    Telegram.sendMessage(
                            feedItem.Body.replaceAll(tagTrash, ' '),
                            token,
                            contactMap.get(feedItem.ParentId).telegramUserId__c);
                }
            }
        }
    }
    public static void manageFeedComments(List<FeedComment> feedComments) {
        List <Id> contactIds = new List <Id>();
        List <Id> feedItemIds = new List <Id>();
        for (FeedComment feedCommentItem : feedComments) {
            contactIds.add(feedCommentItem.parentId);
            feedItemIds.add(feedCommentItem.FeedItemId);
        }
        Map<Id, Contact> contactMap = new Map <Id, Contact>([
                SELECT TelegramUserId__c
                FROM Contact
                WHERE id IN:contactIds
                AND TelegramUserId__c != null
        ]);

        Map<Id, FeedItem> feedItemMap = new Map <Id, FeedItem>([
                SELECT Title
                FROM FeedItem
                WHERE id IN:feedItemIds
        ]);

        for (FeedComment feedCommentItem : feedComments) {
            String messageId = feedItemMap.get(feedCommentItem.FeedItemId).Title;
            if ((feedCommentItem.ParentId != null) && (feedCommentItem.ParentId.getSobjectType().getDescribe().label == 'Contact')) {
                Telegram.sendCommentMessage(
                        messageId,
                        feedCommentItem.CommentBody.replaceAll(tagTrash, ' '),
                        token,
                        contactMap.get(feedCommentItem.ParentId).telegramUserId__c);
            }
        }
    }
/*
    public static void respond(List<FeedComment> feedComments, List<FeedItem> feedItems) {
        User processUser = [SELECT id from User WHERE Name = 'Automated Process'];


        List <Id> contactIds = new List <Id>();
        List <Id> feedItemIds = new List <Id>();
        if (feedComments != null) {

            for (FeedComment feedCommentItem : feedComments) {
                contactIds.add(feedCommentItem.parentId);
                feedItemIds.add(feedCommentItem.FeedItemId);
            }
        } else {
            if (feedItems[0].CreatedById == processUser.Id) {
                for (FeedItem feedItem : feedItems) {
                    contactIds.add(feedItem.parentId);
                }
            }
        }
        Map<Id, Contact> contactMap = new Map <Id, Contact>([
                SELECT TelegramUserId__c
                FROM Contact
                WHERE id IN:contactIds
                AND TelegramUserId__c != null
        ]);

        Map<Id, FeedItem> feedItemMap = new Map <Id, FeedItem>([
                SELECT Title
                FROM FeedItem
                WHERE id IN:feedItemIds
        ]);


        if (!contactMap.isEmpty()) {
            String token = TelegramBot__c.getOrgDefaults().Token__c;
            if (feedComments != null) {
                for (FeedComment feedCommentItem : feedComments) {
                    String messageId = feedItemMap.get(feedCommentItem.FeedItemId).Title;
                    if ((feedCommentItem.ParentId != null) && (feedCommentItem.ParentId.getSobjectType().getDescribe().label == 'Contact')) {
                        // Telegram.sendMessage(feedCommentItem.CommentBody.replaceAll('<[^>]+>', ' '), token, contactMap.get(feedCommentItem.ParentId).telegramUserId__c);
                        Telegram.sendCommentMessage(messageId, feedCommentItem.CommentBody.replaceAll('<[^>]+>', ' '), token, contactMap.get(feedCommentItem.ParentId).telegramUserId__c);
                    }

                }
            } else {
                for (FeedItem feedItem : feedItems) {
                    if ((feedItem.ParentId != null) && (feedItem.ParentId.getSobjectType().getDescribe().label == 'Contact')) {
                        Telegram.sendMessage(feedItem.Body.replaceAll('<[^>]+>', ' '), token, contactMap.get(feedItem.ParentId).telegramUserId__c);
                    }
                }
            }
        }

    }
    */

}