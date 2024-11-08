import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class EmpHomePage extends StatefulWidget {
  const EmpHomePage({super.key});

  @override
  State<EmpHomePage> createState() => _EmpHomePageState();
}

class _EmpHomePageState extends State<EmpHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'EMPLOYEE HOME PAGE',
          style: TextStyle(color: AppColors().navy),
        ),
      ),
    );
  }
}
