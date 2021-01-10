import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:popcorn/bloc/get_now_playing_bloc.dart';
import 'package:popcorn/model/movie.dart';
import 'package:popcorn/model/movie_response.dart';
import 'package:popcorn/style/theme.dart' as style;

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
    return StreamBuilder<MovieResponse>(
        stream: nowPlayingBloc.subject.stream,
        builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.error != null && snapshot.data.error.length > 0) {
              return _buildErrorWidget(
                  snapshot.data.error); //error in data widget
            }
            return _buildNowPlayingWidget(snapshot.data);
          } else if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error); //error widget
          } else {
            return _buildLoadingWidget();
          }
        });
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
          Text("Error occurred: $error"),
        ],
      ),
    );
  }

  Widget _buildNowPlayingWidget(MovieResponse nowPlayingMoviesData) {
    List<Movie> movies = nowPlayingMoviesData.movies;
    if (movies.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("No Movies"),
          ],
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.05,
              MediaQuery.of(context).size.width * 0.03,
              MediaQuery.of(context).size.width * 0.05,
              0.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "New Release",
                  style: TextStyle(
                    height: 1.5,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  "See All",
                  style: TextStyle(
                    letterSpacing: 1.0,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            height: 250,
            child: PageIndicatorContainer(
              align: IndicatorAlign.bottom,
              indicatorSpace: 8.0,
              padding: EdgeInsets.all(5.0),
              indicatorColor: style.Colors.titleColor,
              indicatorSelectorColor: style.Colors.secondaryColor,
              shape: IndicatorShape.circle(size: 6.0),
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: movies.take(5).length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Opacity(
                        opacity: 0.8,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://image.tmdb.org/t/p/original/" +
                                      movies[index].backPoster),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 30.0,
                        child: Container(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          width: 250.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movies[index].title,
                                style: TextStyle(
                                  height: 1.5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              length: movies.take(5).length,
            ),
          ),
        ],
      );
    }
  }
}
