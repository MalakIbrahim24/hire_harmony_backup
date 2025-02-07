import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/widgets/admin/services_list.dart';

class EditedServicesPage extends StatefulWidget {
  final String uid; // User ID

  const EditedServicesPage({super.key, required this.uid});

  @override
  State<EditedServicesPage> createState() => _EditedServicesPageState();
}

class _EditedServicesPageState extends State<EditedServicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors().transparent,
        iconTheme: IconThemeData(
          color: AppColors().white, // White Back Arrow
        ),
      ),
      body: Stack(children: [
        // Background Image
        Positioned.fill(
          child: Image.asset(
            'lib/assets/images/logo_navy.PNG',
            fit: BoxFit.cover,
          ),
        ),
        // Blur Effect
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: AppColors().navy.withValues(alpha: 0.3),
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              Text(
                'Deleted Services',
                style: GoogleFonts.montserratAlternates(
                  color: AppColors().white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: ServicesList(
                  userId: widget.uid, // Pass correct userId
                  subCollection: 'deletedServices', // Sub-collection path
                  action: 'deleted_at', // Firestore timestamp field
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
