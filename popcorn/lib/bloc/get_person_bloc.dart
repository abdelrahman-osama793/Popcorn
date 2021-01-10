import 'package:popcorn/model/person_response.dart';
import 'package:popcorn/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class PersonListBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<PersonResponse> _personResponseSubject =
  BehaviorSubject<PersonResponse>();

  getMovies() async{
    PersonResponse response = await _repository.getPersons();
    _personResponseSubject.sink.add(response);
  }

  dispose() {
    _personResponseSubject.close();
  }

  BehaviorSubject<PersonResponse> get subject=> _personResponseSubject;
}

final personBloc = PersonListBloc();