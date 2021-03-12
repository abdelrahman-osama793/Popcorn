import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:popcorn/bloc/get_now_playing_bloc.dart';
import 'package:popcorn/model/movie.dart';
import 'package:popcorn/model/movie_response.dart';
import 'package:popcorn/screens/details_screen.dart';
import 'package:popcorn/style/text_styles.dart';
import 'package:popcorn/style/theme.dart' as style;

import 'loading_error_widgets/loading_widget.dart';

class NowPlayingWidget extends StatefulWidget {
  @override
  _NowPlayingWidgetState createState() => _NowPlayingWidgetState();
}

class _NowPlayingWidgetState extends State<NowPlayingWidget> {
  @override
  void initState() {
    super.initState();
    nowPlayingBloc.getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * .04,
            top: MediaQuery.of(context).size.width * .02,
          ),
          child: Text(
            "NOW PLAYING MOVIES",
            style: kSectionTitleFontStyle,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * .01,
        ),
        StreamBuilder<MovieResponse>(
            stream: nowPlayingBloc.subject.stream,
            builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.error != null && snapshot.data.error.length > 0) {
                  return _buildErrorWidget(snapshot.data.error); //error in data widget
                }
                return _buildNowPlayingWidget(snapshot.data);
              } else if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error); //error widget
              } else {
                return LoadingWidget();
              }
            }),
      ],
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

  Widget _buildNowPlayingWidget(MovieResponse nowPlayingMoviesData) {
    List<Movie> nowPlayingMovies = nowPlayingMoviesData.movies;
    if (nowPlayingMovies.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "No Movies",
              style: kFontStyle14,
            ),
          ],
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: nowPlayingMovies.take(10).length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * .03,
                    MediaQuery.of(context).size.height * .015,
                    MediaQuery.of(context).size.width * .01,
                    MediaQuery.of(context).size.height * .02,
                  ),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => DetailsScreen(movie: nowPlayingMovies[index])));
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * .85,
                          height: MediaQuery.of(context).size.height * .28,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white12,
                                offset: Offset(0.0, 2.0),
                                blurRadius: 6.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20.0),
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://image.tmdb.org/t/p/original/" + nowPlayingMovies[index].backPoster),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: MediaQuery.of(context).size.width * .05,
                          child: Container(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * .04,
                              right: 10.0,
                            ),
                            width: MediaQuery.of(context).size.width * .5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nowPlayingMovies[index].title,
                                  style: TextStyle(
                                    height: 1.5,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  children: [
                                    Icon(
                                      EvaIcons.star,
                                      color: style.Colors.secondaryColor,
                                      size: 15.0,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * .01,
                                    ),
                                    Text(
                                      (nowPlayingMovies[index].rating).toString(),
                                      style: kFontStyle14,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }
  }
}
