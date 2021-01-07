import 'package:dio/dio.dart';
import 'package:popcorn/model/genre_response.dart';
import 'package:popcorn/model/movie.dart';
import 'package:popcorn/model/movie_response.dart';
import 'package:popcorn/model/person_response.dart';

class MovieRepository {
  final String apiKey = "<<themoviedb.org - c6a909474b2065a2bb14199a819e5414>>";
  static String mainUrl = "api.themoviedb.org/3";
  final Dio _dio = Dio();

  var getPopularityUrl = "$mainUrl/movie/top_rated";
  var getMoviesUrl = "$mainUrl/discover/movie";
  var getPlayingUrl = "$mainUrl/movie/now_playing";
  var getGenresUrl = "$mainUrl/genre/movie/list";
  var getPersonsUrl = "$mainUrl/trending/person/week";

  Future<MovieResponse> getMovies() async {
    var params = {
      "api_key": apiKey,
      "language": "en-US",
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
      "api_key": apiKey,
      "language": "en-US",
      "page": 1,
    };
    try {
      Response response =
          await _dio.get(getPlayingUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error) {
      return MovieResponse.withError("$error");
    }
  }

  Future<GenreResponse> getGenres() async {
    var params = {
      "api_key": apiKey,
      "language": "en-US",
      "page": 1,
    };
    try {
      Response response = await _dio.get(getGenresUrl, queryParameters: params);
      return GenreResponse.fromJson(response.data);
    } catch (error) {
      return GenreResponse.withError("$error");
    }
  }

  Future<PersonResponse> getPersons() async {
    var params = {
      "api_key": apiKey,
    };
    try {
      Response response = await _dio.get(getPersonsUrl, queryParameters: params);
      return PersonResponse.fromJson(response.data);
    } catch (error) {
      return PersonResponse.withError("$error");
    }
  }

  Future<MovieResponse> getMovieByGenre(int id) async {
    var params = {
      "api_key": apiKey,
      "language": "en-US",
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
