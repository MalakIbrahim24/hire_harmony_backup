import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class OrderTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final Color statusColor;
  final String sentTime;
  final String sentDate; // Add sentDate

  const OrderTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusColor,
    required this.sentTime,
    required this.sentDate, // Require sentDate
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors().pearl,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        // Use Padding to wrap the content
        padding: const EdgeInsets.all(10),
        child: Column(
          // Use a Column to arrange date, title, and subtitle
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align content to the start
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  // Use Expanded to prevent overflow
                  child: Text(
                    title,
                    style: GoogleFonts.montserratAlternates(
                      fontSize: 15,
                      color: AppColors().navy,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis, // Add overflow handling
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.montserratAlternates(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      subtitle,
                      style: GoogleFonts.montserratAlternates(
                        fontSize: 10,
                        color: AppColors().grey2,
                      ),
                      overflow: TextOverflow.ellipsis, // Add overflow handling
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    // Use Expanded to prevent overflow
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        sentTime,
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 12,
                          color: AppColors().grey2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              // Display the date at the top
              sentDate,
              style: GoogleFonts.montserratAlternates(
                fontSize: 10,
                color: AppColors().grey2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
