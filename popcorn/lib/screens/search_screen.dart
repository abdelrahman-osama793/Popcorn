import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:popcorn/bloc/search_bloc.dart';
import 'package:popcorn/model/movie.dart';
import 'package:popcorn/model/movie_response.dart';
import 'package:popcorn/screens/details_screen.dart';
import 'package:popcorn/style/text_styles.dart';
import 'package:popcorn/style/theme.dart' as style;
import 'package:popcorn/widget/loading_error_widgets/loading_widget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    searchBloc..search("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * .08,
              right: MediaQuery.of(context).size.width * .03,
              left: MediaQuery.of(context).size.width * .03,
            ),
            // Search Text Field
            child: TextFormField(
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
              controller: _searchController,
              onChanged: (changed) {
                searchBloc..search(_searchController.text);
              },
              decoration: InputDecoration(
                fillColor: Colors.white10,
                border: InputBorder.none,
                hintText: "What would like to find?",
                hintStyle: TextStyle(
                  color: Colors.white30,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                filled: true,
                prefixIcon: IconButton(
                  icon: Icon(
                    EvaIcons.arrowBack,
                    color: style.Colors.secondaryColor,
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
                suffixIcon: IconButton(
                    icon: Icon(
                      Icons.clear_outlined,
                      color: style.Colors.secondaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _searchController.clear();
                        searchBloc..search(_searchController.text);
                      });
                    }),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white10,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: style.Colors.secondaryColor,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * .05,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<MovieResponse>(
              stream: searchBloc.searchResponse.stream,
              builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.error != null && snapshot.data.error.length > 0) {
                    return _buildEmptySearchWidget();
                  }
                  return _buildSearchedResults(snapshot.data);
                } else if (snapshot.hasError) {
                  return _buildErrorWidget(snapshot.data.error);
                } else {
                  return LoadingWidget();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearchWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Column(
              children: [
                Icon(
                  EvaIcons.searchOutline,
                  color: Colors.white30,
                  size: 80,
                ),
                Text(
                  "What movie would you like to find?",
                  style: kFontStyle14.copyWith(
                    color: Colors.white30,
                  ),
                ),
              ],
            ),
          ),
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

  Widget _buildSearchedResults(MovieResponse data) {
    List<Movie> searchMovies = data.movies;
    return ListView.builder(
      itemCount: searchMovies.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DetailsScreen(movie: searchMovies[index])));
          },
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * .05,
                  MediaQuery.of(context).size.width * .02,
                  MediaQuery.of(context).size.width * .05,
                  MediaQuery.of(context).size.width * .04,
                ),
                child: Container(
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * .16,
                  ),
                  height: MediaQuery.of(context).size.height * .16,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * .2,
                      MediaQuery.of(context).size.width * .05,
                      MediaQuery.of(context).size.width * .02,
                      MediaQuery.of(context).size.width * .05,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          searchMovies[index].title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              EvaIcons.starOutline,
                              size: 20.0,
                              color: style.Colors.secondaryColor,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .02,
                            ),
                            Text(
                              searchMovies[index].rating.toString() + "/10",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              EvaIcons.heartOutline,
                              color: style.Colors.secondaryColor,
                              size: 20.0,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .02,
                            ),
                            Text(
                              searchMovies[index].popularity.toString(),
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.width * .03,
                left: MediaQuery.of(context).size.width * .05,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white12,
                        offset: Offset(0.0, 2.0),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: searchMovies[index].poster == null
                      ? Center(
                          child: Icon(
                          EvaIcons.filmOutline,
                          size: 120.0,
                          color: style.Colors.secondaryColor,
                        ))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image(
                            height: MediaQuery.of(context).size.height * .15,
                            width: MediaQuery.of(context).size.width * .3,
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              "https://image.tmdb.org/t/p/original/" + searchMovies[index].poster,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
