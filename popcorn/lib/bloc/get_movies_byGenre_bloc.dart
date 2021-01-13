import 'package:flutter/material.dart';
import 'package:popcorn/model/movie_response.dart';
import 'package:popcorn/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class MoviesListByGenreBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _movieByGenreResponseSubject =
  BehaviorSubject<MovieResponse>();

  getMoviesByGenre(int id) async{
    MovieResponse response = await _repository.getMovieByGenre(id);
    _movieByGenreResponseSubject.sink.add(response);
  }
  void drainStream() => _movieByGenreResponseSubject.value = null;
  @mustCallSuper
  void dispose() async{
    await _movieByGenreResponseSubject.drain();
    _movieByGenreResponseSubject.close();
  }

  BehaviorSubject<MovieResponse> get subject=> _movieByGenreResponseSubject;
}

final moviesByGenreBloc = MoviesListByGenreBloc();