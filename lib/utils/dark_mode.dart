import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: AppColors().white,
    inversePrimary: AppColors().navy,
    secondary: Colors.grey.shade700,
    tertiary: Colors.grey.shade800,
    error: AppColors().red, // لون الأخطاء
    onPrimary: AppColors().grey3, // لون النص على العناصر الأساسية

    onSecondary: AppColors().orange,
    // لون النص على العناصر الثانوية
  ),

  textTheme: GoogleFonts.montserratAlternatesTextTheme(), // ✅ ضبط الخط
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors().navy, // ✅ الخلفية الداكنة
    indicatorColor: AppColors().orange, // ✅ لون المؤشر عند التحديد
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return GoogleFonts.montserratAlternates(
          color: Colors.white, // ✅ اللون عند التحديد
          fontWeight: FontWeight.bold,
        );
      }
      return GoogleFonts.montserratAlternates(
        color: AppColors().greylight, // ✅ اللون عند عدم التحديد
      );
    }),
  ),
);
