import 'package:dio/dio.dart';
import 'package:popcorn/model/genre_response.dart';
import 'package:popcorn/model/movie_response.dart';
import 'package:popcorn/model/person_response.dart';

class MovieRepository {
  final String _apiKey = "c6a909474b2065a2bb14199a819e5414";
  final Dio _dio = Dio();

  var getPopularityUrl = "https://api.themoviedb.org/3/movie/top_rated";
  var getMoviesUrl = "https://api.themoviedb.org/3/discover/movie";
  var getPlayingUrl = "https://api.themoviedb.org/3/movie/now_playing";
  var getGenresUrl = "https://api.themoviedb.org/3/genre/movie/list";
  var getPersonsUrl = "https://api.themoviedb.org/3/trending/person/week";

  Future<MovieResponse> getMovies() async {
    var params = {
      "api_key": _apiKey,
      "page": 1,
    };
    try {
      Response response =
          await _dio.get(getPopularityUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error) {
      return MovieResponse.withError("$error");
    }
  }

  Future<MovieResponse> getPlayingNowMovies() async {
    var params = {
      "api_key": _apiKey,
      "page": 1,
    };
    try {
      Response response =
          await _dio.get(getPlayingUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }

  Future<GenreResponse> getGenres() async {
    var params = {
      "api_key": _apiKey,
      "page": 1,
    };
    try {
      Response response = await _dio.get(getGenresUrl, queryParameters: params);
      return GenreResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return GenreResponse.withError("$error");
    }
  }

  Future<PersonResponse> getPersons() async {
    var params = {
      "api_key": _apiKey,
    };
    try {
      Response response =
          await _dio.get(getPersonsUrl, queryParameters: params);
      return PersonResponse.fromJson(response.data);
    } catch (error) {
      return PersonResponse.withError("$error");
    }
  }

  Future<MovieResponse> getMovieByGenre(int id) async {
    var params = {
      "api_key": _apiKey,
      "page": 1,
      "with_genres": id,
    };
    try {
      Response response = await _dio.get(getMoviesUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error) {
      return MovieResponse.withError("$error");
    }
  }
}
