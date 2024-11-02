import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/view_models/cubit/adnhome_cubit.dart';

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
            body: Padding(
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
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors().navy,
                                    fontSize: 28,
                                  ),
                            ),
                            Text(
                              'Welcome to your Control Panel',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    color: AppColors().grey2,
                                    fontSize: 16,
                                  ),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          backgroundColor: AppColors().navy,
                          child: Icon(Icons.notifications_active,
                              color: AppColors().white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Manage Your App',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors().navy,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Display the Control Cards from Firestore
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: state.controlCards,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        } else {
          // If no valid state is present, return an empty container
          return const SizedBox();
        }
      },
    );
  }
}
