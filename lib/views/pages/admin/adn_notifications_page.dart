import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class AdnNotificationsPage extends StatefulWidget {
  const AdnNotificationsPage({super.key});

  @override
  State<AdnNotificationsPage> createState() => _AdnNotificationsPageState();
}

class _AdnNotificationsPageState extends State<AdnNotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColors().orange.withOpacity(0.3),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 30,
                color: AppColors().white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}
