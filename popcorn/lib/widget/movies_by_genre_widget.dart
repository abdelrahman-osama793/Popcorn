import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:popcorn/bloc/get_movies_byGenre_bloc.dart';
import 'package:popcorn/model/movie.dart';
import 'package:popcorn/model/movie_response.dart';
import 'package:popcorn/screens/details_screen.dart';
import 'package:popcorn/style/text_styles.dart';
import 'package:popcorn/style/theme.dart' as style;

class MoviesByGenreWidget extends StatefulWidget {
  final int genreId;

  const MoviesByGenreWidget({Key key, @required this.genreId})
      : super(key: key);
  @override
  _MoviesByGenreWidgetState createState() => _MoviesByGenreWidgetState(genreId);
}

class _MoviesByGenreWidgetState extends State<MoviesByGenreWidget> {
  final int genreId;
  _MoviesByGenreWidgetState(this.genreId);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    moviesByGenreBloc..getMoviesByGenre(genreId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
        stream: moviesByGenreBloc.subject.stream,
        builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.error != null && snapshot.data.error.length > 0) {
              return _buildErrorWidget(
                  snapshot.data.error); //error in data widget
            }
            return _buildMoviesByGenreWidget(snapshot.data);
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
          Text(
            "Error occurred: $error",
            style: kFontStyle14,
          ),
        ],
      ),
    );
  }

  Widget _buildMoviesByGenreWidget(MovieResponse moviesData) {
    List<Movie> moviesByGenre = moviesData.movies;
    if (moviesByGenre.length == 0) {
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
      return Container(
        // The container that contains the list of movies selected according to genres
        height: MediaQuery.of(context).size.height * .3,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: moviesByGenre.length,
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(movie: moviesByGenre[index])));
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * .3,
                  width: MediaQuery.of(context).size.width * .4,
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * .02),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.black38,
                  ),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(
                        bottom: 5,
                        child: Container(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * .02,
                            top: MediaQuery.of(context).size.width * .08,
                          ),
                          height: MediaQuery.of(context).size.height * .08,
                          width: MediaQuery.of(context).size.width * .38,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * .35,
                                child: Text(
                                  moviesByGenre[index].title,
                                  maxLines: 1,
                                  style: kFontStyle14.copyWith(
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    EvaIcons.star,
                                    color: style.Colors.secondaryColor,
                                    size: 10.0,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .01,
                                  ),
                                  Text(
                                    moviesByGenre[index].rating.toString(),
                                    style: kFontStyle14.copyWith(
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      //containers that contain the posters, movies and rating
                      moviesByGenre[index].poster == null
                          ? Container(
                              //in case of no poster
                              width: MediaQuery.of(context).size.width * .3,
                              height: MediaQuery.of(context).size.height * .3,
                              decoration: BoxDecoration(
                                color: style.Colors.secondaryColor,
                                borderRadius: BorderRadius.circular(2.0),
                                shape: BoxShape.rectangle,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    EvaIcons.filmOutline,
                                    color: Colors.white,
                                    size: 50.0,
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              // if poster is available
                              width: MediaQuery.of(context).size.width * .35,
                              height: MediaQuery.of(context).size.height * .2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white12,
                                    offset: Offset(0.0, 2.0),
                                    blurRadius: 6.0,
                                  ),
                                ],
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "http://image.tmdb.org/t/p/w200/" +
                                          moviesByGenre[index].poster),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
