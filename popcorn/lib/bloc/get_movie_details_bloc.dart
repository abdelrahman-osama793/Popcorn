import 'package:flutter/material.dart';
import 'package:popcorn/model/movie_details_response.dart';
import 'package:popcorn/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class GetMovieDetailsBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieDetailsResponse> _movieDetailsSubject = BehaviorSubject<MovieDetailsResponse>();

  getMovieDetails(int movieId) async{
    MovieDetailsResponse response = await _repository.getMovieDetails(movieId);
    _movieDetailsSubject.sink.add(response);
  }

  void drainStream() => _movieDetailsSubject.value = null;
  @mustCallSuper
  void dispose() async{
    await _movieDetailsSubject.drain();
    _movieDetailsSubject.close();
  }

  BehaviorSubject<MovieDetailsResponse> get subject => _movieDetailsSubject;
}

final getMovieDetailsBloc = GetMovieDetailsBloc();