@isTest
public class TMDBCalloutMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('{"revenue": 1000000, "vote_average": 8.5}');
        return res;
    }
}