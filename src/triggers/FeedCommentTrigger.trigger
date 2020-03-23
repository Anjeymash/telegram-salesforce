
trigger FeedCommentTrigger on FeedComment (after insert) {
    TelegramNotificationTriggerHandler.manageFeedComments(Trigger.new);
}