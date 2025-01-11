/*import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    // ignore: deprecated_member_use
    background: Colors.grey.shade900,
    primary: Colors.grey.shade600,
    inversePrimary: Colors.grey.shade300,
    secondary: Colors.grey.shade700,
    tertiary: Colors.grey.shade800,
  ),
);*/
import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    // ignore: deprecated_member_use
    background: Colors.grey.shade900,
    primary: Colors.grey.shade600,
    inversePrimary: Colors.grey.shade300,
    secondary: Colors.grey.shade700,
    tertiary: Colors.grey.shade800,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white), // النص الأساسي
    bodyMedium: TextStyle(color: Colors.white70), // النص الثانوي
    displayLarge: TextStyle(color: Colors.white), // العناوين الكبيرة
    displayMedium: TextStyle(color: Colors.white70), // العناوين المتوسطة
    displaySmall: TextStyle(color: Colors.white70), // العناوين الصغيرة
    bodySmall: TextStyle(color: Colors.white60), // النصوص التوضيحية
    labelLarge: TextStyle(color: Colors.white), // نص الأزرار
  ),
);
