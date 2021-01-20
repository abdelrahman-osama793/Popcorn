import 'package:flutter/material.dart';
import 'package:popcorn/model/cast_response.dart';
import 'package:popcorn/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class GetCastBloc{
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<CastResponse> _castResponseSubject = BehaviorSubject<CastResponse>();

  getCast(int movieId) async{
    CastResponse response = await _repository.getCast(movieId);
    _castResponseSubject.sink.add(response);
  }

  void drainStream() => _castResponseSubject.value = null;
  @mustCallSuper
  void dispose() async{
    await _castResponseSubject.drain();
    _castResponseSubject.close();
  }

  BehaviorSubject<CastResponse> get subject => _castResponseSubject;
}

final getCastBloc = GetCastBloc();