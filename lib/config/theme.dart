import 'package:flutter/material.dart';

const ColorScheme gramolaColorScheme = ColorScheme(
  brightness: Brightness.dark,

  primary: Color.fromARGB(255, 149, 1, 136),
  onPrimary: Color.fromARGB(255, 255, 255, 255),
  
  secondary: Color.fromARGB(255, 0, 139, 139),
  onSecondary: Color.fromARGB(255, 255, 255, 255),

  surface: Color.fromARGB(255, 149, 1, 136),
  onSurface: Color.fromARGB(255, 255, 255, 255),

  background: Color.fromARGB(255, 102, 50, 50),
  onBackground: Colors.white,

  error: Colors.redAccent,
  onError: Color.fromARGB(255, 255, 216, 216)
);

final ThemeData gramolaBaseTheme = ThemeData(
  // Define the default brightness and colors.
  brightness: gramolaColorScheme.brightness,
  colorScheme: gramolaColorScheme

  // Define the default font family.
  //fontFamily: 'Georgia',

  // Define the default `TextTheme`. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  // textTheme: const TextTheme(
  //   headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
  //   headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
  //   bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
  // ),
);



class GramolaColors {
  const GramolaColors();

  static const Color appBarTitle = Color(0xFFFFFFFF);
  static const Color appBarIconColor = Color(0xFFFFFFFF);
  static const Color appBarDetailBackground = Color(0x00FFFFFF);
  static const Color appBarGradientStart = Color(0xFF3383FC);
  static const Color appBarGradientEnd = Color(0xFF00C6FF);

  static const Color eventCard = Color.fromARGB(255, 149, 1, 136);
  static const Color eventPageBackground = Color(0xFF736AB7);
  static const Color eventTitle = Color(0xFFFFFFFF);
  static const Color eventArtist = Color(0xFFFFFFFF);
  static const Color eventLocation = Color(0xFFFFFFFF);
  static const Color eventDate = Color(0xFFFFFFFF);

}

class Dimens {
  const Dimens();

  static const eventWidth = 100.0;
  static const eventHeight = 100.0;
}

class TextStyles {

  const TextStyles();

  static const TextStyle eventTitle = TextStyle(
    color: GramolaColors.eventTitle,
    fontFamily: 'Cataclysme',
    fontWeight: FontWeight.w600,
    fontSize: 22.0
  );

  static const TextStyle eventArtist = TextStyle(
    color: GramolaColors.eventArtist,
    fontFamily: 'FrederickatheGreat',
    fontWeight: FontWeight.bold,
    fontSize: 20.0
  );

  static const TextStyle eventLocation = TextStyle(
    color: GramolaColors.eventLocation,
    fontFamily: 'FrederickatheGreat',
    fontWeight: FontWeight.normal,
    fontSize: 16.0
  );

  static const TextStyle eventDate = TextStyle(
    color: GramolaColors.eventDate,
    fontFamily: 'FrederickatheGreat',
    fontWeight: FontWeight.normal,
    fontSize: 16.0
  );

}