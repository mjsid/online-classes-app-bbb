import 'package:flutter/material.dart';

ThemeData themeData = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: Colors.deepOrangeAccent[700],
    highlightColor: Color.fromRGBO(10, 29, 150, 1),
    accentColor: Colors.white,
    backgroundColor: Colors.deepOrange[700],
    textTheme: TextTheme(
      headline4: TextStyle(color: Colors.white, fontSize: 22),
      headline5: TextStyle(color: Colors.white, fontSize: 20),
      headline6: TextStyle(color: Colors.white, fontSize: 18),
      subtitle2: TextStyle(color: Colors.black, fontSize: 20),
      subtitle1: TextStyle(
        color: Colors.black,
        fontSize: 22,
      ),
      bodyText1: TextStyle(
        color: Colors.black,
        fontSize: 22,
      ),
      bodyText2: TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
      caption: TextStyle(
        color: Colors.black,
        fontSize: 18,
      ),
    ),
    appBarTheme: AppBarTheme(color: Colors.deepOrange[700]));
