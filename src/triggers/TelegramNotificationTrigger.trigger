
trigger TelegramNotificationTrigger on TelegramNotification__e (after insert) {
    TelegramNotificationTriggerHandler.manageNotification(Trigger.new);
}