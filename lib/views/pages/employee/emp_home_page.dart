import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/api/firebase_api.dart';
import 'package:hire_harmony/services/employee_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/pages/employee/advertisement_screen.dart';
import 'package:hire_harmony/views/pages/employee/booking_screen.dart';
import 'package:hire_harmony/views/pages/employee/display_items.dart';
import 'package:hire_harmony/views/pages/employee/tickets_page.dart';
import 'package:hire_harmony/views/pages/location_page.dart';
import 'package:hire_harmony/views/widgets/employee/overview_card.dart';
import 'package:hire_harmony/views/widgets/employee/prev_work.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmpHomePage extends StatefulWidget {
  const EmpHomePage({super.key});

  @override
  State<EmpHomePage> createState() => _EmpHomePageState();
}

class _EmpHomePageState extends State<EmpHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String userName = "User"; // Default user name
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  final EmployeeService employeeService = EmployeeService(); // ✅ استدعاء `EmployeeService`


@override
void initState() {
  super.initState();
  _checkUserLocation();
}


  Future<void> _checkUserLocation() async {
    await Future.delayed(const Duration(seconds: 4));

    final isLocationSaved = await FirebaseApi().isUserLocationSaved(userId!);

    if (!isLocationSaved) {
      // تحويل المستخدم إلى صفحة الموقع باستخدام GetX
      await Get.to(() => const LocationPage());
    }
  }


  @override
  Widget build(BuildContext context) {
    final String? loggedInUserId = FirebaseAuth.instance.currentUser?.uid;

    // Firestore stream to listen for pending requests
    final Stream<QuerySnapshot> pendingRequestsStream = FirebaseFirestore
        .instance
        .collection('users')
        .doc(loggedInUserId)
        .collection('recievedRequests')
        .where('status', isEqualTo: 'pending')
        .snapshots();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors().navy,
                AppColors().brown,
                AppColors().orange,
                Theme.of(context).colorScheme.inversePrimary,
                Theme.of(context).colorScheme.inversePrimary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 10),
                         // ✅ استخدام FutureBuilder لتحميل اسم المستخدم
                  FutureBuilder<String>(
                    future: employeeService.fetchUserName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(
                          'Loading...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return const Text(
                          'Error loading name',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return Text(
                          'Welcome, ${snapshot.data ?? "User"}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserratAlternates(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        );
                      }
                    },
                  ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, right: 10),
                      child: Image.asset(
                        'lib/assets/images/logo_orange.PNG',
                        width: 45, // Bigger logo for better visibility
                        height: 45,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overview',
                  style: GoogleFonts.montserratAlternates(
                    textStyle: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                StreamBuilder<QuerySnapshot>(
                  stream: pendingRequestsStream,
                  builder: (context, snapshot) {
                    int pendingCount = 0;

                    if (snapshot.hasData) {
                      pendingCount = snapshot.data!.docs.length;
                    }

                    return GridView.count(
                      crossAxisSpacing: 1, // Reduced spacing between columns
                      mainAxisSpacing: 2,
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        OverviewCard(
                          title: 'Booking',
                          icon: Icons.book_online_outlined,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BookingScreen(),
                              ),
                            );
                          },
                          cardColor: Theme.of(context).colorScheme.surface,
                          iconColor: Theme.of(context).colorScheme.primary,
                          badgeCount: pendingCount, // ✅ Display badge here
                        ),
                        OverviewCard(
                          title: 'Post Ad',
                          icon: Icons.post_add,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AdvertisementScreen(),
                              ),
                            );
                          },
                          cardColor: Theme.of(context).colorScheme.surface,
                          iconColor: Theme.of(context).colorScheme.primary,
                        ),
                        OverviewCard(
                          title: 'Items',
                          icon: Icons.living_outlined,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DisplayItems(),
                              ),
                            );
                          },
                          cardColor: Theme.of(context).colorScheme.surface,
                          iconColor: Theme.of(context).colorScheme.primary,
                        ),
                        Card(
                          color: AppColors().transparent,
                          elevation: 0,
                        ),
                        OverviewCard(
                          title: 'Tickets',
                          icon: Icons.list,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TicketsPage(),
                              ),
                            );
                          },
                          cardColor: Theme.of(context).colorScheme.surface,
                          iconColor: Theme.of(context).colorScheme.primary,
                        ),
                        Card(
                          color: AppColors().transparent,
                          elevation: 0,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                const PrevWork(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

