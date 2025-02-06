 import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/pages/employee/help_support_page.dart';
 Widget buildAdminCard(BuildContext context,
      {required String name,
      required String role,
      required String image,
      required String adminId,
      required String adminJob}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: AppColors().orange,
          border: Border.all(color: AppColors().orangelight, width: 1),
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(image),
                ),
                const SizedBox(width: 50),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.montserratAlternates(
                        textStyle: TextStyle(
                          fontSize: 17,
                          color: AppColors().white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      adminJob,
                      style: GoogleFonts.montserratAlternates(
                        textStyle: TextStyle(
                          fontSize: 13,
                          color: AppColors().white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors().white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14.0,
                          vertical: 8.0,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HelpSupportPage(adminId: adminId),
                          ),
                        );
                      },
                      child: Text(
                        "Send",
                        style: TextStyle(
                          color: AppColors().navy,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

