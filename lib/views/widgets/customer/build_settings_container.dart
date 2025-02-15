import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hire_harmony/services/auth_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/utils/route/app_routes.dart';
import 'package:hire_harmony/view_models/cubit/auth_cubit.dart';
import 'package:hire_harmony/views/pages/activity_log_page.dart';
import 'package:hire_harmony/views/pages/customer/account_deletion_page.dart';
import 'package:hire_harmony/views/pages/employee/tickets_page.dart';
import 'package:hire_harmony/views/widgets/main_button.dart';

// ignore: camel_case_types
class buildSettingsContainer extends StatefulWidget {
  const buildSettingsContainer({super.key});

  @override
  State<buildSettingsContainer> createState() => _buildSettingsContainerState();
}

// ignore: camel_case_types
class _buildSettingsContainerState extends State<buildSettingsContainer> {
  final AuthServices authServices = AuthServicesImpl();

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);

    return Center(
      child: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (previous, current) =>
            current is AuthFailure || current is AuthInitial,
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors().red,
              ),
            );
          } else if (state is AuthInitial) {
            Navigator.of(context, rootNavigator: true)
                .pushReplacementNamed(AppRoutes.loginPage);
          }
        },
        buildWhen: (previous, current) =>
            current is AuthLoading || current is AuthFailure,
        builder: (context, state) {
          if (state is AuthLoading) {
            return const MainButton(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Column(
                    children: _buildMenuItems(context, authCubit),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  final String? loggedInUserId = FirebaseAuth.instance.currentUser?.uid;
  String userid = '';

  List<Widget> _buildMenuItems(BuildContext context, AuthCubit authCubit) {
    final menuItems = [
      {
        'icon': Icons.info,
        'text': 'Delete Account',
        'route': const AccountDeletionScreen(),
      },
      {
        'icon': Icons.card_membership_outlined,
        'text': 'Tickets',
        'route': const TicketsPage(),
      },
      {
        'icon': Icons.card_membership_outlined,
        'text': 'Activity log',
        'route': ActivityLogPage(uid: loggedInUserId ?? ''),
      },
    ];

    return menuItems
        .map(
          (item) => Column(
            children: [
              ListTile(
                leading: Icon(
                  item['icon'] as IconData,
                  color: AppColors().orange,
                ),
                title: Text(item['text'] as String),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  if (item['route'] != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => item['route'] as Widget,
                      ),
                    );
                  } else if (item['action'] != null) {
                    // Safely call the action with a null check
                    (item['action'] as Function)();
                  }
                },
              ),
            ],
          ),
        )
        .toList();
  }
}
