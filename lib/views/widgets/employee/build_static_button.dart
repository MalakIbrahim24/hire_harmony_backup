import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';

Widget buildStaticButton(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    decoration: BoxDecoration(
      color: AppColors().orange,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Text(
      text,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );
}
