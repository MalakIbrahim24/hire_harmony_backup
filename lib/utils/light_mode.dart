import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';


ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    primary: AppColors().navy, // اللون الأساسي
    secondary: AppColors().orange, // اللون الثانوي
    surface: AppColors().white, // لون السطح
    error: AppColors().red, // لون الأخطاء
    onPrimary: AppColors().greylight, // لون النص على العناصر الأساسية
    onSecondary: AppColors().greylight, 
    inversePrimary: AppColors().navy2,
    tertiary:AppColors().grey, // لون النص على العناصر الثانوية
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      color: AppColors().navy,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      color: AppColors().navy2,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: AppColors().black,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: AppColors().grey,
      fontSize: 14,
    ),
    titleMedium: TextStyle(
      color: AppColors().teal,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: TextStyle(
      color: AppColors().pearl,
      fontSize: 16,
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors().white, // لون الخلفية للتطبيق
    titleTextStyle: TextStyle(
      color: AppColors().navy,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: AppColors().navy,
    ),
  ),
);
