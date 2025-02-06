import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/services/customer_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/pages/customer/view_emp_profile_page.dart';
import 'package:hire_harmony/views/pages/map_page.dart';
import 'package:hire_harmony/views/widgets/shimmer_page.dart';

class EmployeesUnderCategoryPage extends StatefulWidget {
  final String categoryName; // اسم الفئة

  const EmployeesUnderCategoryPage({required this.categoryName, super.key});

  @override
  State<EmployeesUnderCategoryPage> createState() =>
      _EmployeesUnderCategoryPageState();
}

class _EmployeesUnderCategoryPageState
    extends State<EmployeesUnderCategoryPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool filterByDistance = false; // 🔹 متغير لتفعيل الفلترة
  Position? currentPosition; // 🔹 موقع المستخدم الحالي
  String selectedFilter = "None"; // 🔹 الفلتر الافتراضي
  final CustomerServices _customerServices = CustomerServices();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
  }

  Future<void> _loadUserLocation() async {
    Position? position = await _customerServices.getCurrentLocation();
    setState(() {
      currentPosition = position;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Employees for ${widget.categoryName}',
          style: GoogleFonts.montserratAlternates(
            color: AppColors().white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors().white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColors().orange,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_list, color: AppColors().white),
            onSelected: (String value) {
              setState(() {
                selectedFilter = value;
              });
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: "None",
                child: Text("No Filter"),
              ),
              const PopupMenuItem(
                value: "Near",
                child: Text("Sort by Distance"),
              ),
              const PopupMenuItem(
                value: "Rating",
                child: Text("Sort by Rating"),
              ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const ShimmerPage()
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: _customerServices.fetchEmployeesByCategory(
                  widget.categoryName, currentPosition, selectedFilter),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ShimmerPage();
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                final employees = snapshot.data;
                if (employees == null || employees.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'lib/assets/images/logo_orange.PNG',
                          width: 120,
                          height: 120,
                        ),
                        const Text('No employees found for this category'),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: employees.length,
                  itemBuilder: (context, index) {
                    final employee = employees[index];
                    final employeeName = employee['name'] ?? 'Unknown Employee';
                    final employeeImg = employee['img'] ?? '';
                    final employeeId = employee['uid'];
                    final employeeRating =
                        employee['rating']; // ✅ الريتينج الآن double

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ViewEmpProfilePage(employeeId: employeeId),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: employeeImg.isNotEmpty
                                        ? NetworkImage(employeeImg)
                                        : null,
                                    backgroundColor: AppColors().navy,
                                    child: employeeImg.isEmpty
                                        ? const Icon(Icons.person,
                                            color: Colors.white)
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          employeeName,
                                          style:
                                              GoogleFonts.montserratAlternates(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "Distance: ${employee['distance'].toStringAsFixed(2)} km",
                                          style:
                                              GoogleFonts.montserratAlternates(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.star,
                                                color: Colors.orange, size: 16),
                                            const SizedBox(width: 4),
                                            Text(
                                              employeeRating.toStringAsFixed(
                                                  1), // ✅ عرض الريتينج بعد تحويله
                                              style: GoogleFonts
                                                  .montserratAlternates(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios,
                                      color: Colors.grey),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MapScreen(employeeId: employeeId),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors().orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                ),
                                child: const Text(
                                  'See Location',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
