import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class EmpBuildMenuContainer extends StatelessWidget {
  final String title; // Title for the menu item
  final IconData icon; // Icon for the menu item
  final VoidCallback? onTap; // Action when the menu item is tapped
  final int? badgeCount; // Optional badge count for the menu item

  const EmpBuildMenuContainer({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors().black.withValues(alpha: 0.1),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon,color: Theme.of(context).colorScheme.primary,size: 26),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,

                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (badgeCount != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badgeCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
