import 'package:popcorn/model/genre_response.dart';
import 'package:popcorn/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class GenreListBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<GenreResponse> _genreResponseSubject =
  BehaviorSubject<GenreResponse>();

  getGenres() async{
    GenreResponse response = await _repository.getGenres();
    _genreResponseSubject.sink.add(response);
  }

  dispose() {
    _genreResponseSubject.close();
  }

  BehaviorSubject<GenreResponse> get subject=> _genreResponseSubject;
}

final genresBloc = GenreListBloc();
