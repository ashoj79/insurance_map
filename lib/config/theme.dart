import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Colors.blue,
    surface: Color(0xFFF3F7FA),
    background: Color(0xFFF3F7FA)
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24)
    )
  ),
  fontFamily: "vazirmatn"
);