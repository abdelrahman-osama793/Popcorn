import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {
  final YoutubePlayerController youtubePlayerController;

  const VideoScreen({Key key, this.youtubePlayerController}) : super(key: key);
  @override
  _VideoScreenState createState() => _VideoScreenState(youtubePlayerController);
}

class _VideoScreenState extends State<VideoScreen> {
  final YoutubePlayerController youtubePlayerController;
  _VideoScreenState(this.youtubePlayerController);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Stack(
        children: [
          Center(
            child: YoutubePlayer(controller: youtubePlayerController),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * .1,
            right: MediaQuery.of(context).size.width * .03,
            child: IconButton(
                icon: Icon(
                  EvaIcons.closeCircleOutline,
                  color: Colors.white,
                ),
                onPressed: (){
                  Navigator.pop(context);
                }),
          )
        ],
      ),
    );
  }
}
