global class MockMovieList implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(200);

        String jsonResponse = '{' +
            '"page": 1,' +
            '"results": [' +
                '{ "adult": false, "backdrop_path": "/hZkgoQYus5vegHoetLkCJzb17zJ.jpg", "genre_ids": [18, 53, 35], "id": 550, "original_language": "en", "original_title": "Fight Club", "overview": "A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy. Their concept catches on, with underground \\"fight clubs\\" forming in every town, until an eccentric gets in the way and ignites an out-of-control spiral toward oblivion.", "popularity": 73.433, "poster_path": "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg", "release_date": "1999-10-15", "title": "Fight Club", "video": false, "vote_average": 8.433, "vote_count": 26279 },' +
                '{ "adult": false, "backdrop_path": "/1VqE5z4VIOcNcajJuHLk4fDkY9G.jpg", "genre_ids": [28, 27], "id": 289732, "original_language": "zh", "original_title": "屍城", "overview": "It\'s the end of the century at a corner of the city in a building riddled with crime - Everyone in the building has turned into zombies. After Jenny\'s boyfriend is killed in a zombie attack, she faces the challenge of surviving in the face of adversity. In order to stay alive, she struggles with Andy to flee danger.", "popularity": 15.263, "poster_path": "/u8u3KVq0qfJYmNDsaTVOXy4So6f.jpg", "release_date": "2014-10-23", "title": "Zombie Fight Club", "video": false, "vote_average": 4.721, "vote_count": 52 },' +
                '{ "adult": false, "backdrop_path": null, "genre_ids": [35, 18], "id": 323667, "original_language": "ru", "original_title": "Вставай и бейся", "overview": "Intertwined stories from the gladiator/athletes participating to the Calcio Storico Fiorentino yearly championship.", "popularity": 2.744, "poster_path": "/rPCOC0myV3Vr7nYGMAOAOpUXgH3.jpg", "release_date": "2015-06-21", "title": "Florence Fight Club", "video": false, "vote_average": 5.722, "vote_count": 9 }' +
                '],' +
            '"total_pages": 2,' +
            '"total_results": 39' +
        '}';

        response.setBody(jsonResponse);
        return response;
    }
}