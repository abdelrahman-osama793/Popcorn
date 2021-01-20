import 'package:flutter/material.dart';
import 'package:popcorn/model/movie_response.dart';
import 'package:popcorn/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class GetSimilarMoviesBloc{
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _similarMoviesSubject = BehaviorSubject<MovieResponse>();

  getSimilarMovies(int movieId) async{
    MovieResponse response = await _repository.getSimilarMovies(movieId);
    _similarMoviesSubject.sink.add(response);
  }

  void drainStream() => _similarMoviesSubject.value = null;
  @mustCallSuper
  void dispose() async{
    await _similarMoviesSubject.drain();
    _similarMoviesSubject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _similarMoviesSubject;
}

final similarMoviesBloc = GetSimilarMoviesBloc();