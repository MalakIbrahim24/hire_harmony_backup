import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class BuildStyledCard extends StatelessWidget {
  final String title; // Define as class member
  final IconData icon; // Define as class member
  final VoidCallback? onTap; // Define as class member

  const BuildStyledCard({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9), // Corrected withOpacity
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors().navy, size: 28),
            const SizedBox(width: 15),
            Text(
              title,
              style: GoogleFonts.montserratAlternates(
                fontSize: 18,
                color: AppColors().navy,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
