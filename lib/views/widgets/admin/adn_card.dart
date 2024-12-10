import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';

// factory design pattern was used here
class ControlCard extends StatelessWidget {
  final String cardName;
  final String path;
  final void Function()? onTap;
  final AssetImage img;

  const ControlCard({
    super.key,
    required this.cardName,
    this.onTap,
    required this.img,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: GestureDetector(
        onTap: onTap, // Trigger the onTap function here
        child: Container(
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: AssetImage(path),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                AppColors().navy.withOpacity(0.3), // Adjust opacity level here
                BlendMode.darken,
              ),
            ),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors().navy.withOpacity(0.3),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(15)),
              ),
              child: Text(
                cardName,
                style: GoogleFonts.montserratAlternates(
                    fontSize: 18,
                    color: AppColors().white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  factory ControlCard.fromMap(Map<String, dynamic> data) {
    return ControlCard(
      cardName:
          data['cardName'] ?? 'Unknown', // Default to 'Unknown' if missing
      path: data['path'] ?? '',
      img: const AssetImage('path'), // Default to empty string if missing
    );
  }
}
