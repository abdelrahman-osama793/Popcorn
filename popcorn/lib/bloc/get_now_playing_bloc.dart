import 'package:popcorn/model/movie_response.dart';
import 'package:popcorn/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class NowPlayingListBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _movieResponseSubject =
  BehaviorSubject<MovieResponse>();

  getMovies() async{
    MovieResponse response = await _repository.getPlayingNowMovies();
    _movieResponseSubject.sink.add(response);
  }

  void drainStream() => _movieResponseSubject.value=null;

  void dispose() async{
    await _movieResponseSubject.drain();
    _movieResponseSubject.close();
  }

  BehaviorSubject<MovieResponse> get subject=> _movieResponseSubject;
}

final nowPlayingBloc = NowPlayingListBloc();
