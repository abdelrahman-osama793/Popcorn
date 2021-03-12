import 'package:flutter/material.dart';
import 'package:popcorn/bloc/get_movies_byGenre_bloc.dart';
import 'package:popcorn/model/movie.dart';
import 'package:popcorn/model/movie_response.dart';
import 'package:popcorn/screens/details_screen.dart';
import 'package:popcorn/style/text_styles.dart';
import 'package:popcorn/widget/rounded_rectangle_container.dart';

import 'loading_error_widgets/loading_widget.dart';

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
            return LoadingWidget();
          }
        });
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
            return GestureDetector(
              onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(movie: moviesByGenre[index])));
              },
              child: RoundedRectangleContainer(
                title: moviesByGenre[index].title,
                rating: moviesByGenre[index].rating.toString(),
                poster: moviesByGenre[index].poster,
              ),
            );
          },
        ),
      );
    }
  }
}
