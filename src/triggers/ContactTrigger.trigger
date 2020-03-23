
trigger ContactTrigger on Contact (after insert , after update) {
    Telegram.manageImage(Trigger.new);
}