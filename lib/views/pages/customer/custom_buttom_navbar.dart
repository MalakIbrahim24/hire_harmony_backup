import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/services/customer_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/pages/chat_list_page.dart';
import 'package:hire_harmony/views/pages/customer/community.dart';
import 'package:hire_harmony/views/pages/customer/cus_home_page.dart';
import 'package:hire_harmony/views/pages/customer/cus_profile_page.dart';
import 'package:hire_harmony/views/pages/customer/order_page.dart';

class CustomButtomNavbar extends StatefulWidget {
  const CustomButtomNavbar({super.key});

  @override
  State<CustomButtomNavbar> createState() => _CustomButtomNavbarState();
}

class _CustomButtomNavbarState extends State<CustomButtomNavbar> {
  // final CustomerServices _customerServices = CustomerServices();
  int currentPageIndex = 2;
  int _pendingOrdersCount = 0;

  @override
  void initState() {
    super.initState();
    CustomerServices.instance.listenForPendingOrders().listen((count) {
      if (mounted) {
        setState(() {
          _pendingOrdersCount = count;
        });
      }
    });
  }

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
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .surface
                    .withValues(alpha: 0.85),
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
                    selectedIcon: Stack(
                      children: [
                        Icon(Icons.list, color: AppColors().white),
                        if (_pendingOrdersCount > 0)
                          Positioned(
                            right: -5,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                _pendingOrdersCount.toString(),
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
                    icon: Stack(
                      children: [
                        Icon(
                          Icons.list_alt_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        if (_pendingOrdersCount > 0)
                          Positioned(
                            right: -5,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                _pendingOrdersCount.toString(),
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
                    label: 'My Orders',
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(Icons.home, color: AppColors().white),
                    icon: Icon(
                      Icons.home_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(Icons.living, color: AppColors().white),
                    icon: Icon(
                      Icons.living_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    label: 'Mart',
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(Icons.person, color: AppColors().white),
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
        const OrderPage(),
        const CusHomePage(),
        const Community(),
        const CusProfilePage(),
      ][currentPageIndex],
    );
  }
}
