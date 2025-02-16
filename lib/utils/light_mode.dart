import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    primary: AppColors().navy,
    secondary: AppColors().orange,
    surface: AppColors().white,
    error: AppColors().red,
    onPrimary: AppColors().greylight,
    onSecondary: AppColors().white,
    inversePrimary: AppColors().white,
    tertiary: AppColors().grey,
  ),
  textTheme: GoogleFonts.montserratAlternatesTextTheme(),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors().white,
    titleTextStyle: TextStyle(
      color: AppColors().navy,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: AppColors().navy,
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors().white,
    indicatorColor: AppColors().orange,
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return GoogleFonts.montserratAlternates(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        );
      }
      return GoogleFonts.montserratAlternates(
        color: AppColors().navy,
      );
    }),
  ),
);
