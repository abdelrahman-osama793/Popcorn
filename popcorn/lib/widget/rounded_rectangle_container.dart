import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:popcorn/style/text_styles.dart';
import 'package:popcorn/style/theme.dart' as style;

class RoundedRectangleContainer extends StatefulWidget {
  const RoundedRectangleContainer({
    @required this.title,
    @required this.rating,
    @required this.poster,
  });

  final String title;
  final String rating;
  final String poster;

  @override
  _RoundedRectangleContainerState createState() => _RoundedRectangleContainerState();
}

class _RoundedRectangleContainerState extends State<RoundedRectangleContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width * .03,
        MediaQuery.of(context).size.height * .015,
        MediaQuery.of(context).size.width * .01,
        MediaQuery.of(context).size.height * .02,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * .3,
        width: MediaQuery.of(context).size.width * .4,
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * .02),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.black38,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            widget.poster == null
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
                              "http://image.tmdb.org/t/p/w200/" + widget.poster),
                          fit: BoxFit.cover,
                        )),
                  ),
            Container(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * .02,
                top: MediaQuery.of(context).size.width * .04,
              ),
              height: MediaQuery.of(context).size.height * .06,
              width: MediaQuery.of(context).size.width * .38,
              decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .35,
                    child: Text(
                      widget.title,
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
                        width: MediaQuery.of(context).size.width * .01,
                      ),
                      Text(
                        widget.rating,
                        style: kFontStyle14.copyWith(
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
