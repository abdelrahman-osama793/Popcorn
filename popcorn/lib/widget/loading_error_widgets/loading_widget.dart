import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:popcorn/style/theme.dart' as style;

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * .3,
        child: SpinKitFadingFour(
          color: style.Colors.secondaryColor,
          size: 50,
        ),
      ),
    );
  }
}
