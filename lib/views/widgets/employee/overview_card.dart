import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class OverviewCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final Color cardColor;
  final Color iconColor;
  final int badgeCount; // New: Count of pending requests

  const OverviewCard({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    required this.cardColor,
    required this.iconColor,
    this.badgeCount = 0, // Default: No badge
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Card(
            color: cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: iconColor, size: 30),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserratAlternates(
                        fontSize: 14,             color: Theme.of(context).colorScheme.primary,
),
                  ),
                ],
              ),
            ),
          ),
          // ✅ Show the red badge if there are pending requests
          if (badgeCount > 0)
            Positioned(
              top: 5,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors().orange,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$badgeCount', // Display number of pending requests
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}