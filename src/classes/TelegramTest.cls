@IsTest
private class TelegramTest {
    static testMethod void test_sendMessage() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TelegramCalloutMock());
        Telegram.sendMessage('test', '1234', '0000');
        Test.stopTest();
    }

    static testMethod void test_sendError() {
        TelegramBot__c bot_setting = new TelegramBot__c();
        bot_setting.Token__c = '1234';
        insert bot_setting;

        TelegramCredential__c credential = new TelegramCredential__c();
        credential.User__c = UserInfo.getUserId();
        credential.TelegramId__c = '0000';
        insert credential;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TelegramCalloutMock());
        Telegram.sendNotification('test');
        Test.stopTest();
    }
}