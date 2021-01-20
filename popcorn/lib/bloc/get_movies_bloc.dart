import 'package:popcorn/model/movie_response.dart';
import 'package:popcorn/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class MoviesListBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _movieResponseSubject =
      BehaviorSubject<MovieResponse>();

  getMovies() async{
    MovieResponse response = await _repository.getMovies();
    _movieResponseSubject.sink.add(response);
  }

  dispose() => _movieResponseSubject.close();


  BehaviorSubject<MovieResponse> get subject=> _movieResponseSubject;
}

final moviesListBloc = MoviesListBloc();

