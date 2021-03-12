import 'package:popcorn/model/movie_response.dart';
import 'package:popcorn/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _searchResponse = BehaviorSubject<MovieResponse>();

  search(String searchValue) async {
    MovieResponse response = await _repository.getSearch(searchValue);
    _searchResponse.sink.add(response);
  }

  dispose() {
    _searchResponse.close();
  }

  BehaviorSubject<MovieResponse> get searchResponse => _searchResponse;
}

final searchBloc = SearchBloc();
