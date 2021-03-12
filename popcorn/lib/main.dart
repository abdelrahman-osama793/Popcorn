import 'package:flutter/material.dart';
import 'package:popcorn/screens/home_screen.dart';
import 'package:popcorn/style/theme.dart' as style;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PopCorn',
      theme: ThemeData(
        cursorColor: style.Colors.secondaryColor,
        scaffoldBackgroundColor: style.Colors.primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
