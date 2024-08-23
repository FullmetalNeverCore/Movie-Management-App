public class TmdbHttpMock implements HttpCalloutMock {
        private Boolean isPositive;

        public TmdbHttpMock(Boolean isPositive) {
            this.isPositive = isPositive;
        }

        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(isPositive ? 200 : 400);

            if (isPositive) {
                if (req.getEndpoint().contains('/genre/movie/list')) {
                    res.setBody('{"genres":[{"id":28,"name":"Action"},{"id":12,"name":"Adventure"}]}');
                } else if (req.getEndpoint().contains('/movie/123/videos')) {
                    res.setBody('{"results":[{"id":"678","key":"abcd1234","site":"YouTube"}]}');
                } else if (req.getEndpoint().contains('/search/movie')) {
                    res.setBody('{"results":[{"id":123,"title":"Inception"}]}');
                } else if (req.getEndpoint().contains('/movie/123')) {
                    res.setBody('{"id":123,"title":"Inception","overview":"A thief who steals corporate secrets."}');
                }
            } else {
                res.setBody('{"status_message": "An error occurred"}');
            }
            return res;
        }
    }