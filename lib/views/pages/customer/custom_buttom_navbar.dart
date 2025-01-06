import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/services/chat/cubit/chat_cubit.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/pages/chat_page.dart';
import 'package:hire_harmony/views/pages/customer/cus_home_page.dart';
import 'package:hire_harmony/views/pages/customer/cus_profile_page.dart';
import 'package:hire_harmony/views/pages/customer/favorites_page.dart';
import 'package:hire_harmony/views/pages/customer/order_page.dart';
class CustomButtomNavbar extends StatefulWidget {
  const CustomButtomNavbar({super.key});

  @override
  State<CustomButtomNavbar> createState() => _CustomButtomNavbarState();
}

class _CustomButtomNavbarState extends State<CustomButtomNavbar> {
  int currentPageIndex = 2;

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
            const SizedBox(height: 16),
            Container(
              width: 400,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/images/office2.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_circle_outlined,
                    color: AppColors().navy, size: 30),
                const SizedBox(width: 8),
                Text(
                  'Good Afternoon, Haneen',
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 18,
                    color: AppColors().navy,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors().navy,
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
                backgroundColor: AppColors().white.withOpacity(0.85),
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
                      color: AppColors().navy,
                    ),
                    label: 'Messages',
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(Icons.list, color: AppColors().white),
                    icon:
                        Icon(Icons.list_alt_outlined, color: AppColors().navy),
                    label: 'My Order',
                  ),
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
      body: <Widget>[
        BlocProvider(
          create: (context) {
            final cubit = ChatCubit();
            cubit.getMessages();
            return cubit;
          },
          child: const ChatPage(),
        ),
        const OrderPage(),
        const CusHomePage(),
        const FavoritesPage(),
        const CusProfilePage(),
      ][currentPageIndex],
    );
  }
}
