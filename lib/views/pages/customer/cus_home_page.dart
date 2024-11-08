import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class CusHomePage extends StatefulWidget {
  const CusHomePage({super.key});

  @override
  State<CusHomePage> createState() => _CusHomePageState();
}

class _CusHomePageState extends State<CusHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'CUSTOMER HOME PAGE',
          style: TextStyle(color: AppColors().navy),
        ),
      ),
    );
  }
}
