import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/widgets/admin/services_list.dart';

class EditedServicesPage extends StatefulWidget {
  const EditedServicesPage({super.key});

  @override
  State<EditedServicesPage> createState() => _EditedServicesPageState();
}

class _EditedServicesPageState extends State<EditedServicesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Set focus on "Deleted Services" tab (index 1)
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors().navy,
        iconTheme: IconThemeData(
          color: AppColors().white, // White Back Arrow
        ),
        title: Text(
          'Edited Services',
          style: GoogleFonts.montserratAlternates(
            color: AppColors().white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors().white,
          indicatorColor: AppColors().orange,
          tabs: const [
            Tab(text: "Added Services"),
            Tab(text: "Deleted Services"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ServicesList(collection: 'added_services', action: 'added_at'),
          ServicesList(collection: 'deleted_services', action: 'deleted_at'),
        ],
      ),
    );
  }
}
