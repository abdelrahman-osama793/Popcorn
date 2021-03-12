import 'package:flutter/material.dart';
import 'package:popcorn/bloc/get_similar_movies_bloc.dart';
import 'package:popcorn/model/movie.dart';
import 'package:popcorn/model/movie_response.dart';
import 'package:popcorn/screens/details_screen.dart';
import 'package:popcorn/style/text_styles.dart';
import 'package:popcorn/widget/rounded_rectangle_container.dart';

import 'loading_error_widgets/loading_widget.dart';

class SimilarMoviesWidget extends StatefulWidget {
  final int movieId;
  const SimilarMoviesWidget({Key key, this.movieId}) : super(key: key);

  @override
  _SimilarMoviesWidgetState createState() => _SimilarMoviesWidgetState(movieId);
}

class _SimilarMoviesWidgetState extends State<SimilarMoviesWidget> {
  final int movieId;
  _SimilarMoviesWidgetState(this.movieId);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    similarMoviesBloc..getSimilarMovies(movieId);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    similarMoviesBloc..drainStream();
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
            "SIMILAR MOVIES",
            style: kSectionTitleFontStyle,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * .01,
        ),
        StreamBuilder<MovieResponse>(
          stream: similarMoviesBloc.subject.stream,
          builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null &&
                  snapshot.data.error.length > 0) {
                return _buildErrorWidget(
                    snapshot.data.error); //error in data widget
              }
              return _buildSimilarMoviesWidget(snapshot.data);
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error); //error widget
            } else {
              return LoadingWidget();
            }
          },
        )
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

  Widget _buildSimilarMoviesWidget(MovieResponse similarMoviesData) {
    List<Movie> similarMovies = similarMoviesData.movies;
    if (similarMovies.length == 0) {
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
        // The container that contains the list of top rated movies
        height: MediaQuery.of(context).size.height * .32,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: similarMovies.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(movie: similarMovies[index])));
              },
              child: RoundedRectangleContainer(
                title: similarMovies[index].title,
                rating: similarMovies[index].rating.toString(),
                poster: similarMovies[index].poster,
              ),
            );
          },
        ),
      );
    }
  }
}
