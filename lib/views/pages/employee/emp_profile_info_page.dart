import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/widgets/employee/build_static_button.dart';
import 'package:hire_harmony/views/widgets/employee/photo_tab_view.dart';
import 'package:hire_harmony/views/widgets/employee/reviews_tab_view.dart';

class EmpProfileInfoPage extends StatefulWidget {
  const EmpProfileInfoPage({super.key});

  @override
  State<EmpProfileInfoPage> createState() => _EmpProfileInfoPageState();
}

class _EmpProfileInfoPageState extends State<EmpProfileInfoPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Employee data fields
  String? profileImageUrl;
  String name = '';
  String location = '';
  String rating = '';
  String aboutMe = '';
  String id = '';
  List<String> services = [];
  num reviewsNum = 0;
  List<Map<String, dynamic>> reviews = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchEmployeeData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchEmployeeData() async {
    try {
      final User? user = _auth.currentUser; // Get logged-in user
      if (user == null) return;

      // Fetch employee document
      final DocumentSnapshot employeeDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (employeeDoc.exists) {
        final data = employeeDoc.data() as Map<String, dynamic>;

        setState(() {
          profileImageUrl = data['img'] ??
              'https://via.placeholder.com/150'; // Default placeholder
          name = data['name'] ?? 'Unknown Name';
          location = data['location'] ?? 'Unknown Location';
          rating = data['rating'] ?? '0.0';
          aboutMe = data['about'] ?? 'No description available.';
          services = List<String>.from(data['services'] ?? []);
          reviewsNum = data['reviews'] ?? 0;
          id = data['uid'] ?? 'User ID not found';
        });
      }

      // Fetch employee reviews
      final QuerySnapshot reviewsSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('reviews')
          .get();

      setState(() {
        reviews = reviewsSnapshot.docs.map((doc) {
          final reviewData = doc.data() as Map<String, dynamic>;
          return {
            'name': reviewData['name'] ?? 'Anonymous',
            'rating': reviewData['rating'] ?? '0.0',
            'date': reviewData['date'] ?? '',
            'review': reviewData['review'] ?? 0,
            'image': reviewData['image'] ??
                'https://via.placeholder.com/50', // Default avatar
          };
        }).toList();
      });
    } catch (e) {
      debugPrint('Error fetching employee data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: profileImageUrl != null
                          ? Image.network(
                              profileImageUrl!,
                              width: 160,
                              height: 160,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const CircularProgressIndicator();
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 160),
                            )
                          : const CircularProgressIndicator(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Name, Location, and Rating
                  Center(
                    child: Column(
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors().navy2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on,
                                color: AppColors().orange, size: 20),
                            const SizedBox(width: 4),
                            Text(location,
                                style: GoogleFonts.montserratAlternates(
                                  fontSize: 14,
                                  color: Colors.grey,
                                )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star,
                                color: AppColors().orange, size: 20),
                            const SizedBox(width: 4),
                            Text('$rating ($reviewsNum reviews)',
                                style: GoogleFonts.montserratAlternates(
                                  fontSize: 14,
                                  color: Colors.grey,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // About Me
                  Text(
                    'About me',
                    style: GoogleFonts.montserratAlternates(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors().navy2),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    aboutMe,
                    style: GoogleFonts.montserratAlternates(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // My Services
                  Text(
                    'My Services',
                    style: GoogleFonts.montserratAlternates(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors().navy2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: services
                          .map((service) => Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: buildStaticButton(service),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tabs Section
                  TabBar(
                    controller: _tabController,
                    labelColor: AppColors().orange,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: AppColors().orange,
                    tabs: const [
                      Tab(text: 'Photos'),
                      Tab(text: 'Review'),
                    ],
                  ),
                  SizedBox(
                    height: 400, // Height of TabBarView
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Photos & Videos Tab
                        PhotoTabView(
                          employeeId: id,
                        ),

                        // Reviews Tab
                        ReviewsTapView(
                          employeeId: id,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
