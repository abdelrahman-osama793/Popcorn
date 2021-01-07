import 'package:popcorn/model/movie_response.dart';
import 'package:popcorn/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class MoviesListBloc {
  final MovieRepository _repository = MovieRepository();
  // ignore: close_sinks
  final BehaviorSubject<MovieResponse> _movieresponsesubject =
      BehaviorSubject<MovieResponse>();

  getMovies() async{
    MovieResponse response = await _repository.getMovies();
    _movieresponsesubject.sink.add(response);
  }

  dispose() {
    _movieresponsesubject.close();
  }

  BehaviorSubject<MovieResponse> get subject=> _movieresponsesubject;
}

final moviesBloc = MoviesListBloc();

