import 'package:flutter/material.dart';
import 'package:popcorn/bloc/get_genre_bloc.dart';
import 'package:popcorn/model/genre.dart';
import 'package:popcorn/model/genre_response.dart';
import 'package:popcorn/style/text_styles.dart';
import 'package:popcorn/widget/genres_list_widget.dart';

import 'loading_error_widgets/loading_widget.dart';

class GenresWidget extends StatefulWidget {
  @override
  _GenresWidgetState createState() => _GenresWidgetState();
}

class _GenresWidgetState extends State<GenresWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    genresListBloc..getGenres();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GenreResponse>(
        stream: genresListBloc.subject.stream,
        builder: (context, AsyncSnapshot<GenreResponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.error != null && snapshot.data.error.length > 0) {
              return _buildErrorWidget(snapshot.data.error); //error in data widget
            }
            return _buildGenresWidget(snapshot.data);
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
            style: TextStyle(
              height: 1.5,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenresWidget(GenreResponse genreResponseData) {
    List<Genre> genres = genreResponseData.genres;
    if (genres.length == 0) {
      return Container(
        child: Text(
          "No Genres",
          style: kFontStyle14,
        ),
      );
    } else {
      return GenresListWidget(genres: genres);
    }
  }
}
