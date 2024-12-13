import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/utils/route/app_routes.dart';
import 'package:hire_harmony/view_models/cubit/adnhome_cubit.dart';
import 'package:hire_harmony/views/widgets/admin/adn_card.dart';

class AdnHomePage extends StatefulWidget {
  const AdnHomePage({super.key});

  @override
  State<AdnHomePage> createState() => _AdnHomePageState();
}

class _AdnHomePageState extends State<AdnHomePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AdnHomeCubit>(context).loadData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdnHomeCubit, AdnHomeState>(
      builder: (context, state) {
        if (state is AdnHomeLoading) {
          // Show a loading indicator when data is being fetched
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else if (state is AdnHomeError) {
          // Show an error message if data fails to load
          return Center(
            child: Text(state.message),
          );
        } else if (state is AdnHomeLoaded) {
          // Once data is loaded, display the control cards
          return Scaffold(
            backgroundColor: AppColors().white,
            body: Stack(children: [
              Positioned.fill(
                child: Image.asset(
                  'lib/assets/images/notf.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              // Blur Filter
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 17.0, sigmaY: 17.0),
                  child: Container(
                    color: AppColors().navy.withValues(alpha: 0.3),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hi Malak',
                                style: GoogleFonts.montserratAlternates(
                                  fontSize: 28,
                                  color: AppColors().white,
                                ),
                              ),
                              Text(
                                'Welcome to your Control Panel',
                                style: GoogleFonts.montserratAlternates(
                                  fontSize: 16,
                                  color: AppColors().grey,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            child: CircleAvatar(
                              backgroundColor: AppColors().navy,
                              child: Icon(Icons.notifications_active,
                                  color: AppColors().white),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.adnnotificationsPage);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Manage Your App',
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 20,
                          color: AppColors().white,
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Display the Control Cards from Firestore
                      Expanded(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ControlCard(
                              cardName: 'Service Management',
                              path: 'lib/assets/images/ServManage.jpeg',
                              img: const AssetImage(
                                  'lib/assets/images/ServManage.jpeg'),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.editServicesPage);
                              },
                            ),
                            ControlCard(
                              cardName: 'AD Management',
                              path: 'lib/assets/images/adManage.jpg',
                              img: const AssetImage(
                                  'lib/assets/images/adManage.jpg'),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.adManagementPage);
                              },
                            ),
                            ControlCard(
                              cardName: 'Accounts Control',
                              path: 'lib/assets/images/accControl.jpeg',
                              img: const AssetImage(
                                  'lib/assets/images/accControl.jpeg'),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.userManagementPage);
                              },
                            ),
                            ControlCard(
                              cardName: 'Category Management',
                              path: 'lib/assets/images/catgManage.webp',
                              img: const AssetImage(
                                  'lib/assets/images/catgManage.webp'),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.categoryManagementPage);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ]),
          );
        } else {
          // If no valid state is present, return an empty container
          return const SizedBox();
        }
      },
    );
  }
}
