global class MockGenreList implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
      
        HTTPResponse res = new HTTPResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);

      
        String jsonResponse = '{' +
            '"genres": [' +
                '{ "id": 28, "name": "Action" },' +
                '{ "id": 12, "name": "Adventure" },' +
                '{ "id": 16, "name": "Animation" },' +
                '{ "id": 35, "name": "Komödie" },' +
                '{ "id": 80, "name": "Krimi" },' +
                '{ "id": 99, "name": "Dokumentarfilm" },' +
                '{ "id": 18, "name": "Drama" },' +
                '{ "id": 10751, "name": "Familie" },' +
                '{ "id": 14, "name": "Fantasy" },' +
                '{ "id": 36, "name": "Historie" },' +
                '{ "id": 27, "name": "Horror" },' +
                '{ "id": 10402, "name": "Musik" },' +
                '{ "id": 9648, "name": "Mystery" },' +
                '{ "id": 10749, "name": "Liebesfilm" },' +
                '{ "id": 878, "name": "Science Fiction" },' +
                '{ "id": 10770, "name": "TV-Film" },' +
                '{ "id": 53, "name": "Thriller" },' +
                '{ "id": 10752, "name": "Kriegsfilm" },' +
                '{ "id": 37, "name": "Western" }' +
            ']' +
        '}';

     
        res.setBody(jsonResponse);

        return res;
    }
}