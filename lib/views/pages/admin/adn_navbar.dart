import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/view_models/cubit/adnhome_cubit.dart';
import 'package:hire_harmony/views/pages/admin/adn_home_page.dart';
import 'package:hire_harmony/views/pages/admin/adn_messages_page.dart';
import 'package:hire_harmony/views/pages/admin/adn_profile_page.dart';

class AdnNavbar extends StatefulWidget {
  const AdnNavbar({super.key});

  @override
  State<AdnNavbar> createState() => _AdnNavbarState();
}

class _AdnNavbarState extends State<AdnNavbar> {
  Widget? _child;
  @override
  void initState() {
    _child = const AdnHomePage();
    super.initState(); // Initialize controller
  }

  // List<PersistentTabConfig> _navBarsItems() {
  //   return [

  //   ];
  // }

  @override
  Widget build(BuildContext context) {
    // final user = AuthCubit();
    // final myuser = user.getCurrentUser();
    return BlocProvider(
        create: (context) {
          final cubit = AdnHomeCubit();

          return cubit;
        },
        child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: _child,
          bottomNavigationBar: FluidNavBar(
            icons: [
              FluidNavBarIcon(
                icon: Icons.message_outlined,
                backgroundColor:
                    AppColors().transparent, // Transparent when not selected
                selectedForegroundColor:
                    AppColors().orange, // Set to teal when selected
                unselectedForegroundColor:
                    AppColors().navy, // White when not selected
                extras: {"label": "Messages"},
              ),
              FluidNavBarIcon(
                icon: Icons.home_repair_service_outlined,
                backgroundColor: Colors.transparent,
                selectedForegroundColor: AppColors().orange,
                unselectedForegroundColor: AppColors().navy,
                extras: {"label": "Home"},
              ),
              FluidNavBarIcon(
                icon: Icons.person_2_outlined,
                backgroundColor: Colors.transparent,
                selectedForegroundColor: AppColors().orange,
                unselectedForegroundColor: AppColors().navy,
                extras: {"label": "Profile"},
              ),
            ],
            onChange: _handleNavigationChange,
            style: FluidNavBarStyle(
              barBackgroundColor: AppColors()
                  .orange2
                  .withOpacity(0.4), // Main background color of the bar
              iconBackgroundColor:
                  AppColors().orange2, // Set selected icon background to teal
            ),
            scaleFactor: 1.5,
            defaultIndex: 1,
            itemBuilder: (icon, item) => Semantics(
              label: icon.extras!["label"],
              child: item,
            ),
          ),
        ));
  }

  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          _child = const AdnMessagesPage();
          break;
        case 1:
          _child = const AdnHomePage();
          break;
        case 2:
          _child = const AdnProfilePage();
          break;
      }
      _child = AnimatedSwitcher(
        // switchInCurve: Curves.easeInCirc,
        // switchOutCurve: Curves.elasticOut,
        duration: const Duration(milliseconds: 200),
        child: _child,
      );
    });
  }
}
