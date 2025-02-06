import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/pages/chat_list_page.dart';
import 'package:hire_harmony/views/pages/employee/emp_home_page.dart';
import 'package:hire_harmony/views/pages/employee/emp_order_page.dart';
import 'package:hire_harmony/views/pages/employee/emp_profile_page.dart';

class EmpNavbar extends StatefulWidget {
  const EmpNavbar({super.key});

  @override
  State<EmpNavbar> createState() => _EmpNavbarState();
}

class _EmpNavbarState extends State<EmpNavbar> {
  int currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: size.width >= 800
          ? null
          : NavigationBarTheme(
              data: NavigationBarThemeData(
                labelTextStyle: WidgetStateProperty.all(
                  GoogleFonts.montserratAlternates(
                    textStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500, 
                      color: Theme.of(context).colorScheme.primary,
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
                backgroundColor: Theme.of(context).colorScheme.surface,
                indicatorColor: AppColors().orange,
                selectedIndex: currentPageIndex,
                elevation: 0,
                destinations: <Widget>[
                  NavigationDestination(
                    selectedIcon: Icon(
                      Icons.message,
                      color: AppColors().white,
                    ),
                    icon: Icon(
                      Icons.message_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    label: 'Messages',
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(
                      Icons.home,
                      color: AppColors().white,
                    ),
                    icon: Icon(
                      Icons.home_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(Icons.list, color: AppColors().white),
                    icon: Icon(
                      Icons.list_alt_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    label: 'Orders',
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(
                      Icons.person,
                      color: AppColors().white,
                    ),
                    icon: Icon(
                      Icons.person_2_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
      body: <Widget>[
        const ChatListPage(),
        const EmpHomePage(),
        const EmpOrderPage(),
        const EmpProfilePage(),
      ][currentPageIndex],
    );
  }
}
