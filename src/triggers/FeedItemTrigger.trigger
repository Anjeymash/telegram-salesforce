

trigger FeedItemTrigger on FeedItem (after insert, after update) {
    TelegramNotificationTriggerHandler.manageFeedItems(Trigger.new);
}