import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/services/firestore_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/pages/admin/employee_ads_page.dart';
import 'package:hire_harmony/views/widgets/admin/employee_card.dart';

class AdManagementPage extends StatefulWidget {
  const AdManagementPage({super.key});

  @override
  State<AdManagementPage> createState() => _AdManagementPageState();
}

class _AdManagementPageState extends State<AdManagementPage> {
  String searchQuery = ''; // Holds the current search query

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors().transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
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
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/adManage.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay
          Container(color: AppColors().navy.withOpacity(0.3)),
          Column(
            children: [
              const SizedBox(height: 120),
              Text(
                'Employee Ads Management',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserratAlternates(
                  fontSize: 24,
                  color: AppColors().white,
                ),
              ),
              const SizedBox(height: 20),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery =
                          value.trim().toLowerCase(); // Update search query
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by employee name...',
                    hintStyle: GoogleFonts.montserratAlternates(
                      color: AppColors().white.withOpacity(0.8),
                    ),
                    filled: true,
                    fillColor: AppColors().navy.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.search, color: AppColors().white),
                  ),
                  style: GoogleFonts.montserratAlternates(
                      color: AppColors().white),
                ),
              ),

              const SizedBox(height: 20),

              // Fetch and Display Employees
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: FirestoreService.instance.collectionStream(
                    path: 'users',
                    builder: (data, documentId) => {
                      'id': documentId,
                      'name': data['name'] ?? 'Unnamed',
                    },
                    queryBuilder: (query) =>
                        query.where('role', isEqualTo: 'employee'),
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: GoogleFonts.montserratAlternates(
                            color: AppColors().navy,
                          ),
                        ),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'No employees available',
                          style: GoogleFonts.montserratAlternates(
                            color: AppColors().white,
                          ),
                        ),
                      );
                    }

                    // Filter employees based on the search query
                    final employees = snapshot.data!
                        .where((employee) => employee['name']
                            .toLowerCase()
                            .contains(
                                searchQuery)) // Check if name matches query
                        .toList();

                    if (employees.isEmpty) {
                      return Center(
                        child: Text(
                          'No employees match your search',
                          style: GoogleFonts.montserratAlternates(
                            color: AppColors().white,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: employees.length,
                      itemBuilder: (context, index) {
                        final employee = employees[index];
                        return EmployeeCard(
                          name: employee['name'],
                          description: 'Tap to view created Ads',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EmployeeAdsPage(
                                  employeeId: employee['id'],
                                  employeeName: employee['name'],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
