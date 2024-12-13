import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/pages/customer/cus_home_page.dart';
import 'package:hire_harmony/views/pages/customer/cus_messages_page.dart';
import 'package:hire_harmony/views/pages/favorites_page.dart';
import 'package:hire_harmony/views/pages/profile_page.dart';

class CustomButtomNavbar extends StatefulWidget {
  const CustomButtomNavbar({super.key});

  @override
  State<CustomButtomNavbar> createState() => _CustomButtomNavbarState();
}

class _CustomButtomNavbarState extends State<CustomButtomNavbar> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBody: true,
      drawer: Drawer(
        width: 330,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16), // Add spacing at the top
            Container(
              width: 400, // Set desired width
              height: 200, // Set desired height
              decoration: const BoxDecoration(
                // Make the image circular
                image: DecorationImage(
                  image: AssetImage(
                      'lib/assets/images/office2.jpg'), // Replace with your image asset path
                  fit: BoxFit.cover, // Control how the image fits
                ),
              ),
            ),
            const SizedBox(height: 16), // Spacing between image and text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_circle_outlined,
                    color: AppColors().navy, size: 30),
                const SizedBox(width: 8),
                Text(
                  'Good Afternoon, Haneen',
                  style: GoogleFonts.montserratAlternates(
                    textStyle: TextStyle(
                      fontSize: 18,
                      color: AppColors().navy,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the color of the menu icon
        ),
        backgroundColor: AppColors().orange,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
            color: AppColors().white,
          )
        ],
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_city,
                  color: AppColors().white,
                ),
                Text('Qalqiliya , palestine',
                    style: GoogleFonts.montserratAlternates(
                      color: AppColors().white,
                    )),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: size.width >= 800
          ? null
          : NavigationBarTheme(
              data: NavigationBarThemeData(
                labelTextStyle: WidgetStateProperty.all(
                  GoogleFonts.montserratAlternates(
                    textStyle: TextStyle(
                      fontSize: 12, // Customize font size
                      fontWeight: FontWeight.w500, // Customize font weight
                      color: AppColors().navy, // Customize font color
                    ),
                  ),
                ),
              ),
              child: NavigationBar(
                onDestinationSelected: (int index) {
                  setState(() {
                    currentPageIndex = index;
                  });
                },
                backgroundColor: AppColors().white.withValues(alpha:0.85),
                indicatorColor: AppColors().orange,
                selectedIndex: currentPageIndex,
                elevation: 0,
                destinations: <Widget>[
                  NavigationDestination(
                    selectedIcon: Icon(
                      Icons.home,
                      color: AppColors().white,
                    ),
                    icon: Icon(
                      Icons.home_outlined,
                      color: AppColors().navy,
                    ),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(
                      Icons.message,
                      color: AppColors().white,
                    ),
                    icon: Icon(
                      Icons.message_outlined,
                      color: AppColors().navy,
                    ),
                    label: 'Messages',
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(
                      Icons.favorite,
                      color: AppColors().white,
                    ),
                    icon: Icon(
                      Icons.favorite_border,
                      color: AppColors().navy,
                    ),
                    label: 'Favorite',
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(
                      Icons.person,
                      color: AppColors().white,
                    ),
                    icon: Icon(
                      Icons.person_2_outlined,
                      color: AppColors().navy,
                    ),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
      body: const <Widget>[
        CusHomePage(),
        CusMessagesPage(),
        FavoritesPage(),
        ProfilePage(),
      ][currentPageIndex],
    );
  }
}
