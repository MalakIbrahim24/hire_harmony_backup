import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/api/firebase_api.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/pages/employee/advertisement_screen.dart';
import 'package:hire_harmony/views/pages/employee/booking_screen.dart';
import 'package:hire_harmony/views/pages/employee/display_items.dart';
import 'package:hire_harmony/views/pages/employee/tickets_page.dart';
import 'package:hire_harmony/views/pages/location_page.dart';
import 'package:hire_harmony/views/widgets/employee/prev_work.dart';

class EmpHomePage extends StatefulWidget {
  const EmpHomePage({super.key});

  @override
  State<EmpHomePage> createState() => _EmpHomePageState();
}

class _EmpHomePageState extends State<EmpHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String userName = "User"; // Default user name
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _checkUserLocation();
    fetchUserName(); // Fetch user name when the page initializes
  }

  Future<void> _checkUserLocation() async {
    await Future.delayed(const Duration(seconds: 10)); // الانتظار لمدة 10 ثوانٍ

    // افترض أن لديك Firebase API تتحقق من الموقع
    final isLocationSaved = await FirebaseApi().isUserLocationSaved(userId!);

    if (!isLocationSaved) {
      // تحويل المستخدم إلى صفحة الموقع باستخدام GetX
      await Get.to(() => const LocationPage());
    }
  }

  Future<void> fetchUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch the user's document from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            userName = userDoc['name'] ?? "User"; // Update the username
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching user name: $e");
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
        preferredSize: const Size.fromHeight(100),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors().navy,
                AppColors().brown,
                AppColors().orange,
                AppColors().orangelight,
                AppColors().white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                        Text(
                          textAlign: TextAlign.center,
                          'Welcome, $userName',
                          style: GoogleFonts.montserratAlternates(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, right: 10),
                      child: Image.asset(
                        'lib/assets/images/logo_navy.PNG',
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
                          icon: Icons.book_online,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BookingScreen(),
                              ),
                            );
                          },
                          cardColor: AppColors().orangelight,
                          iconColor: AppColors().navy,
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
                          cardColor: AppColors().orangelight,
                          iconColor: AppColors().navy,
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
                          cardColor: AppColors().orangelight,
                          iconColor: AppColors().navy,
                        ),
                        Card(
                          color: AppColors().white,
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
                          cardColor: AppColors().orangelight,
                          iconColor: AppColors().navy,
                        ),
                        Card(
                          color: AppColors().white,
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

class OverviewCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final Color cardColor;
  final Color iconColor;
  final int badgeCount; // New: Count of pending requests

  const OverviewCard({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    required this.cardColor,
    required this.iconColor,
    this.badgeCount = 0, // Default: No badge
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Card(
            color: cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: iconColor, size: 30),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserratAlternates(
                        fontSize: 14, color: AppColors().navy),
                  ),
                ],
              ),
            ),
          ),
          // ✅ Show the red badge if there are pending requests
          if (badgeCount > 0)
            Positioned(
              top: 5,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors().orange,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$badgeCount', // Display number of pending requests
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class WorkPhotoCard extends StatelessWidget {
  final String image;
  final String title;

  const WorkPhotoCard({super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade200,
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(image, height: 100, fit: BoxFit.cover),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
