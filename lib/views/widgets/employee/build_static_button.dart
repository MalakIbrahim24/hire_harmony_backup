import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';

Widget buildStaticButton(String service) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: AppColors().orange.withOpacity(0.1),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppColors().orange, width: 1),
    ),
    child: Text(
      service,
      style: GoogleFonts.montserratAlternates(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors().orange,
      ),
    ),
  );
}
