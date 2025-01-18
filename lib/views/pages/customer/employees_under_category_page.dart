import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/pages/customer/view_emp_profile_page.dart';

class EmployeesUnderCategoryPage extends StatelessWidget {
  final String categoryId;

  const EmployeesUnderCategoryPage({required this.categoryId, super.key});

  Future<List<Map<String, dynamic>>> fetchEmployees(String categoryId) async {
    final usersCollection = FirebaseFirestore.instance.collection('users');
    final userDocs = await usersCollection.get();

    final filteredUsers = <Map<String, dynamic>>[];

    debugPrint("Selected categoryId: $categoryId");

    for (final userDoc in userDocs.docs) {
      final empCategoriesCollection =
          userDoc.reference.collection('empcategories');
      final matchingCategory = await empCategoriesCollection
          .doc(categoryId) // Use categoryId to match document ID
          .get();

      if (matchingCategory.exists) {
        final userData = userDoc.data();
        userData['uid'] = userDoc.id; // Add employee ID to the data
        filteredUsers.add(userData);
      }
    }

    return filteredUsers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Employees for Category',
          style: GoogleFonts.montserratAlternates(
            color: AppColors().white,
          ),
        ),
        backgroundColor: AppColors().orange,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchEmployees(categoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final employees = snapshot.data;
          if (employees == null || employees.isEmpty) {
            return const Center(
              child: Text('No employees found for this category'),
            );
          }

          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final employee = employees[index];
              final employeeName = employee['name'] ?? 'Unknown Employee';
              final employeeEmail = employee['email'] ?? 'No Email';
              final employeeImg = employee['img'] ?? '';
              final employeeId = employee['uid'];

              return Card(
                margin: const EdgeInsets.symmetric(
                vertical: 8.0, horizontal: 12.0), // تقليل المسافات الخارجية
                elevation: 3, // إضافة ظل خفيف للكارد
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), // زوايا دائرية للكارد
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.all(12.0), // تقليل المسافات داخل الكارد
                  child: Row(
                    children: [
                      // صورة أو أيقونة العامل
                      CircleAvatar(
                        radius: 30, // حجم الصورة
                        backgroundImage: employeeImg.isNotEmpty
                            ? NetworkImage(employeeImg)
                            : null,
                        backgroundColor: AppColors().navy,
                        child: employeeImg.isEmpty
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 12), // مسافة بين الصورة والنصوص
                      // النصوص
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              employeeName,
                              style: GoogleFonts.montserratAlternates(
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  color: AppColors().navy,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Email: $employeeEmail', // نص يعرض البريد الإلكتروني
                              style: GoogleFonts.montserratAlternates(
                                textStyle: TextStyle(
                                  fontSize: 10,
                                  color: AppColors().grey2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // زر عرض الملف الشخصي
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors().orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                        onPressed: () {
                          if (employeeId != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewEmpProfilePage(
                                  employeeId: employeeId, // تمرير معرف العامل
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          'View Profile',
                          style: GoogleFonts.montserratAlternates(
                            textStyle: TextStyle(
                              fontSize: 14,
                              color: AppColors().white,
                            ),
                          ),
                        ),
                      ),
                    ],
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
