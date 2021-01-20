import 'package:dio/dio.dart';
import 'package:popcorn/model/genre_response.dart';
import 'package:popcorn/model/movie_details_response.dart';
import 'package:popcorn/model/movie_response.dart';
import 'package:popcorn/model/cast_response.dart';
import 'package:popcorn/model/video_response.dart';

class MovieRepository {
  final String _apiKey = "c6a909474b2065a2bb14199a819e5414";
  static String _baseUrl = "https://api.themoviedb.org/3";
  final Dio _dio = Dio();

  var getPopularityUrl = "$_baseUrl/movie/top_rated";
  var getMoviesUrl = "$_baseUrl/discover/movie";
  var getPlayingUrl = "$_baseUrl/movie/now_playing";
  var getGenresUrl = "$_baseUrl/genre/movie/list";
  var getMovieDetailsUrl = "$_baseUrl/movie";

  Future<MovieResponse> getMovies() async {
    var params = {
      "api_key": _apiKey,
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
      "api_key": _apiKey,
      "language": "en-US",
      "page": 1,
    };
    try {
      Response response =
          await _dio.get(getPlayingUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace){
    print("Exception occurred: $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }

  Future<GenreResponse> getGenres() async {
    var params = {
      "api_key": _apiKey,
      "language": "en-US",
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

  Future<CastResponse> getCast(int id) async {
    var params = {
      "api_key": _apiKey,
      "language": "en-US",
    };
    try {
      Response response =
          await _dio.get(getMovieDetailsUrl + "/$id" + "/credits", queryParameters: params);
      return CastResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return CastResponse.withError("$error");
    }
  }

  Future<MovieResponse> getMovieByGenre(int id) async {
    var params = {
      "api_key": _apiKey,
      "language": "en-US",
      "page": 1,
      "with_genres": id,
    };
    try {
      Response response = await _dio.get(getMoviesUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }

  Future<MovieDetailsResponse> getMovieDetails(int movieId) async{
    var params = {
      "api_key" : _apiKey,
      "language" : "en_US"
    };
    try{
      Response response = await _dio.get(getMovieDetailsUrl + "/$movieId", queryParameters: params);
      return MovieDetailsResponse.fromJson(response.data);
    } catch(error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return MovieDetailsResponse.withError("$error");
    }
  }

  Future<MovieResponse> getSimilarMovies(int movieId) async {
    var params = {
      "api_key" : _apiKey,
      "language" : "en_US"
    };
    try{
      Response response = await _dio.get(getMovieDetailsUrl + "/$movieId" + "/similar", queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch(error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }

  Future<VideoResponse> getMovieVideos(int movieId) async{
    var params = {
      "api_key" : _apiKey,
      "language" : "en_US"
    };
    try{
      Response response = await _dio.get(getMovieDetailsUrl + "/$movieId" + "/videos", queryParameters: params);
      return VideoResponse.fromJson(response.data);
    } catch(error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return VideoResponse.withError("$error");
    }
  }
}
