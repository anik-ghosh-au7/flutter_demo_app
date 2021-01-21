import 'package:flutter/material.dart';

class CustomTheme {
  ThemeData get theme => ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColorDark: Colors.black,
        primaryColorLight: Colors.white,
        unselectedWidgetColor: Colors.black12,
        shadowColor: Colors.grey,
        secondaryHeaderColor: Colors.black54,
        indicatorColor: Colors.redAccent[100],
        selectedRowColor: Colors.black12.withOpacity(0.025),
        accentColor: Colors.blue.withOpacity(0.5),
        splashColor: Colors.redAccent[100],
        accentIconTheme: IconThemeData(
          size: 25.0,
          color: Colors.white,
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: Colors.blueGrey,
          inactiveTrackColor: Colors.black45,
          trackHeight: 3.0,
          thumbColor: Colors.blueGrey,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
          overlayColor: Colors.black.withAlpha(54),
          overlayShape: RoundSliderOverlayShape(overlayRadius: 14.0),
          valueIndicatorShape: PaddleSliderValueIndicatorShape(),
          valueIndicatorColor: Colors.black45,
          valueIndicatorTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.amber,
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
              fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
          headline2: TextStyle(
            fontSize: 20,
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
          headline3: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          headline4: TextStyle(
            color: Colors.blueGrey,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          headline5: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
          headline6: TextStyle(
            color: Colors.black54,
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
          ),
          subtitle1: TextStyle(
            fontSize: 25,
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
          subtitle2: TextStyle(
            fontSize: 20,
            color: Colors.black54,
          ),
          bodyText1: TextStyle(
            color: Colors.black87,
          ),
          bodyText2: TextStyle(
            fontSize: 18,
            color: Colors.black54,
            letterSpacing: 0.8,
          ),
        ),
      );
}
