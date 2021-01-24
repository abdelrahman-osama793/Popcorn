import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:popcorn/bloc/get_cast_bloc.dart';
import 'package:popcorn/model/cast.dart';
import 'package:popcorn/model/cast_response.dart';
import 'package:popcorn/style/text_styles.dart';

class CastWidget extends StatefulWidget {
  final int movieId;
  const CastWidget({Key key, @required this.movieId}) : super(key: key);
  @override
  _CastWidgetState createState() => _CastWidgetState(movieId);
}

class _CastWidgetState extends State<CastWidget> {
  final int movieId;
  _CastWidgetState(this.movieId);

  @override
  void initState() {
    super.initState();
    getCastBloc..getCast(movieId);
  }

  @override
  void dispose() {
    super.dispose();
    getCastBloc..drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * .03,
            top: MediaQuery.of(context).size.width * .05,
          ),
          child: Text(
            "CAST",
            style: kDetailsPageTitlesStyle,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .01,
        ),
        StreamBuilder(
          stream: getCastBloc.subject.stream,
          builder: (context, AsyncSnapshot<CastResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null &&
                  snapshot.data.error.length > 0) {
                return _buildErrorWidget(snapshot.data.error);
              }
              return _buildCastWidget(snapshot.data);
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error);
            } else {
              return _buildLoadingWidget();
            }
          },
        ),
      ],
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

  Widget _buildCastWidget(CastResponse data) {
    List<Cast> cast = data.cast;
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * .03),
      child: Container(
        // container that contains the list
        height: MediaQuery.of(context).size.height * .25,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: cast.length,
          itemBuilder: (context, int index) {
            return Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * .03,
                bottom: MediaQuery.of(context).size.width * .03,
              ),
              child: Container(
                // container that contains all the actor information
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .01,
                ),
                width: MediaQuery.of(context).size.width * .3,
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    cast[index].profileImg == null
                        ? Container(
                      // in case of no photo
                            height: MediaQuery.of(context).size.height * .15,
                            width: MediaQuery.of(context).size.width * .25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.white12,
                            ),
                            child: Icon(
                              EvaIcons.personOutline,
                              color: Colors.white,
                              size: 50.0,
                            ),
                          )
                        : Container(
                      // if there is a photo
                            height: MediaQuery.of(context).size.height * .15,
                            width: MediaQuery.of(context).size.width * .25,
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
                                  "https://image.tmdb.org/t/p/w300/" +
                                      cast[index].profileImg,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .01,
                    ),
                    Text(
                      // the actor name
                      cast[index].name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        height: 1.4,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .01,
                    ),
                    Text(
                      // the character played by the actor in the movie
                      cast[index].character,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
