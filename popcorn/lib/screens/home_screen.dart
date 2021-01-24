import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:popcorn/style/theme.dart' as style;
import 'package:popcorn/widget/genre_widget.dart';
import 'package:popcorn/widget/now_playing_widget.dart';
import 'package:popcorn/widget/top_rated_movies_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: style.Colors.primaryColor,
      appBar: AppBar(
        backgroundColor: style.Colors.primaryColor,
        centerTitle: true,
        leading: Icon(
          EvaIcons.menu2Outline,
          color: Colors.white,
        ),
        title: Text("Popcorn"),
        actions: [
          IconButton(
            icon: Icon(
              EvaIcons.searchOutline,
              color: Colors.white,
            ),
            onPressed: null,
          )
        ],
      ),
      body: ListView(
        children: [
          NowPlayingWidget(),
          TopRatedMoviesWidget(),
          GenresWidget(),
        ],
      ),
    );
  }
}
