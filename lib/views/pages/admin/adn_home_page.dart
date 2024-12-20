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
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else if (state is AdnHomeError) {
          return Center(
            child: Text(
              state.message,
              style: GoogleFonts.montserratAlternates(
                fontSize: 16,
                color: AppColors().white,
              ),
            ),
          );
        } else if (state is AdnHomeLoaded) {
          return Scaffold(
            backgroundColor: AppColors().white,
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'lib/assets/images/notf.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
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
                                RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.montserratAlternates(
                                      fontSize: 16,
                                      color: AppColors().navy, // Default color
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: 'Welcome to your ',
                                      ),
                                      TextSpan(
                                        text: 'Control Panel',
                                        style: GoogleFonts.montserratAlternates(
                                          color: AppColors()
                                              .white, // White color for 'Control Panel'
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            BlocBuilder<AdnHomeCubit, AdnHomeState>(
                              builder: (context, state) {
                                int unreadCount = 0;
                                if (state is AdnHomeLoaded) {
                                  unreadCount = state.unreadNotificationsCount;
                                }

                                return InkWell(
                                  onTap: () async {
                                    await Navigator.pushNamed(context,
                                        AppRoutes.adnnotificationsPage);

                                    // Reset unread count when returning
                                    final cubit =
                                        // ignore: use_build_context_synchronously
                                        BlocProvider.of<AdnHomeCubit>(context);
                                    cubit.resetUnreadNotifications();
                                  },
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: AppColors().navy,
                                        child: const Icon(
                                          Icons.notifications_active,
                                          color: Colors.white,
                                        ),
                                      ),
                                      if (unreadCount >
                                          0) // Show badge only if unread count > 0
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            constraints: const BoxConstraints(
                                              minWidth: 20,
                                              minHeight: 20,
                                            ),
                                            child: Text(
                                              '$unreadCount',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
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
                        Expanded(
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ControlCard(
                                cardName: 'Service Management',
                                path: 'lib/assets/images/ServManage.jpeg',
                                img: const AssetImage(
                                  'lib/assets/images/ServManage.jpeg',
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.editServicesPage,
                                  );
                                },
                              ),
                              ControlCard(
                                cardName: 'AD Management',
                                path: 'lib/assets/images/adManage.jpg',
                                img: const AssetImage(
                                  'lib/assets/images/adManage.jpg',
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.adManagementPage,
                                  );
                                },
                              ),
                              ControlCard(
                                cardName: 'Accounts Control',
                                path: 'lib/assets/images/accControl.jpeg',
                                img: const AssetImage(
                                  'lib/assets/images/accControl.jpeg',
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.userManagementPage,
                                  );
                                },
                              ),
                              ControlCard(
                                cardName: 'Category Management',
                                path: 'lib/assets/images/catgManage.webp',
                                img: const AssetImage(
                                  'lib/assets/images/catgManage.webp',
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.categoryManagementPage,
                                  );
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
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
