import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    this.text = '', // Default text
    this.font = 18.0, // Default font size
    this.width = double.infinity, // Default width
    this.color = Colors.white, // Default text color
    this.bgColor =
        const Color.fromRGBO(255, 100, 4, 1.0), // Default background color
    this.fontWeight, // Font weight can still be null
    this.radius =
        const BorderRadius.all(Radius.circular(10)), // Default border radius
    this.onPressed,
    this.child, // Added a child parameter for dynamic content (e.g., loader)
  });

  final String text;
  final double font;
  final double width;
  final Color color;
  final Color bgColor;
  final FontWeight? fontWeight;
  final BorderRadiusGeometry radius;
  final VoidCallback? onPressed;
  final Widget? child; // Updated to Widget type for more flexibility

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed, // Default to no action if not provided
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          disabledBackgroundColor:
              bgColor, // Keep background color when disabled
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: radius,
          ),
        ),
        // Conditionally render either the child (loader) or text
        child: child ??
            Text(
              text,
              style: GoogleFonts.montserratAlternates(
                fontSize: font,
                fontWeight: fontWeight ??
                    FontWeight.normal, // Default to normal if not provided
                color: color,
              ),
            ),
      ),
    );
  }

  // Add a copyWith method to mimic the behavior of copyWith()
  MainButton copyWith({
    String? text,
    double? font,
    double? width,
    Color? color,
    Color? bgColor,
    FontWeight? fontWeight,
    BorderRadiusGeometry? radius,
    VoidCallback? onPressed,
    Widget? child, // Add child to copyWith
  }) {
    return MainButton(
      text: text ?? this.text,
      font: font ?? this.font,
      width: width ?? this.width,
      color: color ?? this.color,
      bgColor: bgColor ?? this.bgColor,
      fontWeight: fontWeight ?? this.fontWeight,
      radius: radius ?? this.radius,
      onPressed: onPressed ?? this.onPressed,
      child: child ?? this.child, // Handle child override
    );
  }
}
