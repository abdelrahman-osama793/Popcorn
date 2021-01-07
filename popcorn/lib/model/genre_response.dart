import 'package:popcorn/model/genre.dart';

class GenreResponse {
  final List<Genre> genres;
  final String error;

  GenreResponse(this.genres, this.error);

  GenreResponse.fromJson(Map<String, dynamic> json)
      : genres = (json["results"] as List)
      .map((e) => new Genre.fromJson(e))
      .toList(),
        error = "";

  GenreResponse.withError(String errorValue)
      : genres = List(),
        error = errorValue;
}
