import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade100,
    primary: AppColors().navy,
    inversePrimary: Colors.grey.shade900,
    secondary: Colors.grey.shade200,
    tertiary: Colors.white,
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(color: AppColors().navy, fontSize: 32, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(color: AppColors().navy, fontSize: 28, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: AppColors().navy, fontSize: 16),
    bodyMedium: TextStyle(color: AppColors().navy, fontSize: 14),
    titleMedium: TextStyle(color: AppColors().navy, fontSize: 18),
    titleSmall: TextStyle(color: AppColors().navy, fontSize: 16),
  ),
);
