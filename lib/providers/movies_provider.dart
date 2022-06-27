import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/models/search_response.dart';

class MoviesProvider extends ChangeNotifier {
  //Parameters
  final String _apiKey = '854f6fbc5d10bbac9c2f13c7821777db';
  final String _baseUrl = 'api.themoviedb.org';
  final String _lenguage = 'es-ES';
  List<Movie> onNowPlayingMovies = [];
  List<Movie> popularMovies = [];
  Map<int, List<Cast>> movieCast = {};
  int _popularPage = 0;
  final debouncer = Debouncer(duration: Duration(milliseconds: 500));

  final StreamController<List<Movie>> _suggestionStreamController =
      StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream =>
      _suggestionStreamController.stream;

//Provider builder
  MoviesProvider() {
    print('MoviesProvider inicializado');
    getOnNowPlayingMovies();
    getPopularMovies();
  }
//------------------------------------------------------------------------------
//Generic json data
  Future<String> _getJsonData(String segment, [int page = 1]) async {
    final url = Uri.https(
      _baseUrl,
      segment,
      {
        'api_key': _apiKey,
        'language': _lenguage,
        'page': '$page',
      },
    );

    final response = await http.get(url);
    return response.body;
  }

//
//------------------------------------------------------------------------------
//Now playing movies
  getOnNowPlayingMovies() async {
    final jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    onNowPlayingMovies = nowPlayingResponse.results;
    notifyListeners();
  }

//
//------------------------------------------------------------------------------
//Popular movies
  getPopularMovies() async {
    _popularPage++;
    final jsonData = await _getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);
    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

//
//MovieCast
  Future<List<Cast>> getMovieCast(int movieId) async {
    if (movieCast.containsKey(movieId)) return movieCast[movieId]!;
    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);
    movieCast[movieId] = creditsResponse.cast;
    print('Peticion http de pelicula id $movieId');
    return creditsResponse.cast;
  }

//
//SearchEngine
  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(
      _baseUrl,
      '3/search/movie',
      {
        'api_key': _apiKey,
        'language': _lenguage,
        'query': query,
      },
    );
    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);
    return searchResponse.results;
  }

  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      print('Tenemos valor a buscar: $value');
      final results = await searchMovies(value);
      _suggestionStreamController.add(results);
    };
    final timer = Timer.periodic(
      Duration(milliseconds: 300),
      (_) {
        debouncer.value = searchTerm;
      },
    );
    Future.delayed(
      Duration(milliseconds: 301),
    ).then(
      (_) => timer.cancel(),
    );
  }
}
