import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class SignUpWidget extends StatelessWidget {
  final String userType;
  final String description;
  final IconData? icon;
  final Image image;
  final Function()? onPressed;
  const SignUpWidget(
      {super.key,
      required this.userType,
      required this.description,
      this.icon,
      this.onPressed,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              blurRadius: 30,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors().white,
              radius: 60,
              child: image,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userType,
                    style: GoogleFonts.montserratAlternates(
                      fontSize: 15,
                      color: AppColors().orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: GoogleFonts.montserratAlternates(
                      fontSize: 13,
                      color: AppColors().grey2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
