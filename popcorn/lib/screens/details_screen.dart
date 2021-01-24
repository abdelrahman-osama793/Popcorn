import 'dart:ui';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:popcorn/bloc/get_video_bloc.dart';
import 'package:popcorn/model/movie.dart';
import 'package:popcorn/model/video.dart';
import 'package:popcorn/model/video_response.dart';
import 'package:popcorn/screens/video_screen.dart';
import 'package:popcorn/style/text_styles.dart';
import 'package:popcorn/style/theme.dart' as style;
import 'package:popcorn/widget/cast_widget.dart';
import 'package:popcorn/widget/movie_details_widget.dart';
import 'package:popcorn/widget/similar_movies_widget.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailsScreen extends StatefulWidget {
  final Movie movie;
  DetailsScreen({Key key, @required this.movie}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState(movie);
}

class _DetailsScreenState extends State<DetailsScreen> {
  final Movie movie;
  _DetailsScreenState(this.movie);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoBloc..getVideo(movie.id);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoBloc..drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: style.Colors.primaryColor,
      body: SliverFab(
        floatingPosition:
            FloatingPosition(right: MediaQuery.of(context).size.width * .05),
        expandedHeight: MediaQuery.of(context).size.height * .4,
        floatingWidget: StreamBuilder<VideoResponse>(
          stream: videoBloc.subject.stream,
          builder: (context, AsyncSnapshot<VideoResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null &&
                  snapshot.data.error.length > 0) {
                return _buildErrorWidget(
                    snapshot.data.error); //error in data widget
              }
              return _buildVideoWidget(snapshot.data);
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error); //error widget
            } else {
              return _buildLoadingWidget();
            }
          },
        ),
        slivers: [
          SliverAppBar(
            backgroundColor: style.Colors.primaryColor,
            expandedHeight: MediaQuery.of(context).size.height * .4,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                movie.title.length > 40
                    ? movie.title.substring(0, 35) + "..."
                    : movie.title,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                children: [
                  Container(
                    //container that contains the back poster
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://image.tmdb.org/t/p/original" +
                              movie.backPoster,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 5.0,
                      sigmaY: 5.0,
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          style.Colors.primaryColor.withOpacity(0.9),
                          style.Colors.primaryColor.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    //container that contains the poster
                    top: MediaQuery.of(context).size.height * .1,
                    left: MediaQuery.of(context).size.width * .3,
                    child: Container(
                      height: MediaQuery.of(context).size.height * .25,
                      width: MediaQuery.of(context).size.width * .4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          image: DecorationImage(
                              image: NetworkImage(
                                "http://image.tmdb.org/t/p/w200/" +
                                    movie.poster,
                              ),
                              fit: BoxFit.cover),
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(0.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * .03,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        EvaIcons.star,
                        color: style.Colors.secondaryColor,
                        size: 14.0,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .01,
                      ),
                      Text(
                        movie.rating.toString() + "/10",
                        style: kFontStyle14.copyWith(
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * .03,
                    top: MediaQuery.of(context).size.height * .02,
                  ),
                  child: Text(
                    "OVERVIEW",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .01,
                ),
                Padding(
                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * .03,
                  ),
                  child: Text(
                    movie.overview,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
                ),
                MovieDetailsWidget(movieId: movie.id),
                CastWidget(movieId: movie.id),
                SimilarMoviesWidget(movieId: movie.id),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoWidget(VideoResponse data) {
    List<Video> videos = data.videos;
    return FloatingActionButton(
      backgroundColor: style.Colors.secondaryColor,
      child: Icon(
        EvaIcons.playCircle,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoScreen(
              youtubePlayerController: YoutubePlayerController(
                initialVideoId: videos[0].key,
                flags: YoutubePlayerFlags(
                  autoPlay: true,
                  controlsVisibleAtStart: true,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 25.0,
            width: 25.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 4.0,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Error occurred: $error",
            style: kFontStyle14,
          ),
        ],
      ),
    );
  }
}
