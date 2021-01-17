import 'package:popcorn/model/genre.dart';

class MovieDetails {
  final int id;
  final bool adult;
  final int budget;
  final List<Genre> genres;
  final String releaseDate;
  final int duration;

  MovieDetails(
    this.id,
    this.adult,
    this.budget,
    this.genres,
    this.releaseDate,
    this.duration,
  );

  MovieDetails.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        adult = json["adult"],
        budget = json["budget"],
        genres =
            (json["genres"] as List).map((i) => new Genre.fromJson(i)).toList(),
        releaseDate = json["release_date"],
        duration = json["runtime"];
}
