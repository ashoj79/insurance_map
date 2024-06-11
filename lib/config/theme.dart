import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Colors.blue
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24)
    )
  )
);