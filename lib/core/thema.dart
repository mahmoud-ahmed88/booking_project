import 'package:flutter/material.dart';

const Color kPrimary = Color(0xFF0B3D91);
final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: kPrimary),
  appBarTheme: const AppBarTheme(
    backgroundColor: kPrimary,
    centerTitle: true,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(backgroundColor: kPrimary),
  ),
);
