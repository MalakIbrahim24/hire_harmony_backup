import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class BackIconButton extends StatefulWidget {
  const BackIconButton({super.key});

  @override
  State<BackIconButton> createState() => _BackIconButtonState();
}

class _BackIconButtonState extends State<BackIconButton> {
  bool _isHovered = false; // To keep track of hover state

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: _isHovered
              ? AppColors().orange
              : Colors.transparent, // Background changes on hover
          borderRadius: BorderRadius.circular(25),
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 30,
            color: _isHovered
                ? AppColors().white
                : AppColors().navy, // Arrow color changes on hover
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
