import 'package:flutter/cupertino.dart';
import 'package:popcorn/model/video_response.dart';
import 'package:popcorn/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class GetVideoBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<VideoResponse> _videoSubject = BehaviorSubject<VideoResponse>();

  getVideo(int movieId) async{
    VideoResponse response = await _repository.getMovieVideos(movieId);
    _videoSubject.sink.add(response);
  }

  void drainStream() => _videoSubject.value = null;
  @mustCallSuper
  void dispose() async{
    await _videoSubject.drain();
    _videoSubject.close();
  }

  BehaviorSubject<VideoResponse> get subject => _videoSubject;
}

final videoBloc = GetVideoBloc();