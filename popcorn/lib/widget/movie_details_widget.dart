import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:popcorn/bloc/get_movie_details_bloc.dart';
import 'package:popcorn/model/movie_details.dart';
import 'package:popcorn/model/movie_details_response.dart';
import 'package:popcorn/style/text_styles.dart';
import 'package:popcorn/style/theme.dart' as style;

import 'loading_error_widgets/loading_widget.dart';

class MovieDetailsWidget extends StatefulWidget {
  final int movieId;

  const MovieDetailsWidget({Key key, @required this.movieId}) : super(key: key);

  @override
  _MovieDetailsWidgetState createState() => _MovieDetailsWidgetState(movieId);
}

class _MovieDetailsWidgetState extends State<MovieDetailsWidget> {
  final int movieId;

  _MovieDetailsWidgetState(this.movieId);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMovieDetailsBloc..getMovieDetails(movieId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    getMovieDetailsBloc..drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieDetailsResponse>(
      stream: getMovieDetailsBloc.subject.stream,
      builder: (context, AsyncSnapshot<MovieDetailsResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return _buildErrorWidget(snapshot.data.error); //error in data widget
          }
          return _buildMovieInfoWidget(snapshot.data);
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error); //error widget
        } else {
          return LoadingWidget();
        }
      },
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

  Widget _buildMovieInfoWidget(MovieDetailsResponse data) {
    MovieDetails details = data.movieDetails;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .03),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "BUDGET",
                    style: kDetailsPageTitlesStyle,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .01,
                  ),
                  details.budget == 0
                      ? Text("-",
                          style: TextStyle(
                            color: style.Colors.secondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ))
                      : Text(
                          details.budget.toString() + "\$",
                          style: TextStyle(
                            color: style.Colors.secondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "DURATION",
                    style: kDetailsPageTitlesStyle,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .01,
                  ),
                  Text(
                    details.duration.toString() + "min",
                    style: TextStyle(
                      color: style.Colors.secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "RELEASE DATE",
                    style: kDetailsPageTitlesStyle,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .01,
                  ),
                  Text(
                    details.releaseDate,
                    style: TextStyle(
                      color: style.Colors.secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .02,
        ),
        Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * .03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "GENRES",
                  style: kDetailsPageTitlesStyle,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .01,
                ),
                Container(
                  height: 38,
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * .025),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: details.genres.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * .02,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * .01,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            border: Border.all(
                              width: 1.0,
                              color: Colors.white60,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              details.genres[index].name,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
