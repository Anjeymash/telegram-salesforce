
@isTest
global class TelegramCalloutMock implements HttpCalloutMock {
    global HttpResponse respond (HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setHeader('Content-Type', 'application/json');
        res.setBody(JSON.serialize(
            new Map<String, String>{
                'ok' => 'true',
                'result' => 'message'
            }
        ));
        return res;
    }
}