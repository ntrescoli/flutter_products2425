import 'package:flutter/material.dart';

final ThemeData appThemeData = ThemeData(
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 18, color: Colors.white70),
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.blue,
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 24),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.light,
  ),
);
