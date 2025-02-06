import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hire_harmony/services/auth_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/utils/route/app_routes.dart';
import 'package:hire_harmony/view_models/cubit/auth_cubit.dart';
import 'package:hire_harmony/views/pages/employee/emp_profile_edit_page.dart';
import 'package:hire_harmony/views/pages/settings_page.dart';
import 'package:hire_harmony/views/widgets/customer/state_item.dart';
import 'package:hire_harmony/views/widgets/employee/emp_build_menu_container.dart';
import 'package:hire_harmony/views/widgets/main_button.dart';
import 'package:hire_harmony/views/widgets/shimmer_page.dart';

class EmpProfilePage extends StatefulWidget {
  const EmpProfilePage({super.key});

  @override
  State<EmpProfilePage> createState() => _EmpProfilePageState();
}

class _EmpProfilePageState extends State<EmpProfilePage> {
  final AuthServices authServices = AuthServicesImpl();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _imageUrl;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userData;

  int orderCount = 0;
  int ticketCount = 0;
  int pendingRequestCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchEmployeeData();
    _fetchOrderCount();
    _fetchTicketCount();
    _fetchPendingRequestCount();
  }

  Future<void> _fetchEmployeeData() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return;

      final DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        setState(() {
          userData = doc.data() as Map<String, dynamic>;
          _nameController.text = doc['name'] ?? '';
          _emailController.text = doc['email'] ?? '';
          _imageUrl = doc['img'] ??
              'https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-image-182145777.jpg'; // Placeholder if no image
        });
      }
    } catch (e) {
      debugPrint('Error fetching employee data: $e');
    }
  }

  Future<void> _fetchOrderCount() async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    try {
      final QuerySnapshot ordersSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('completedOrders')
          .get();

      setState(() {
        orderCount = ordersSnapshot.size;
      });
    } catch (e) {
      debugPrint('Error fetching order count: $e');
    }
  }

  Future<void> _fetchTicketCount() async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    try {
      final QuerySnapshot ticketsSnapshot = await _firestore
          .collection('ticketsSent')
          .where('uid', isEqualTo: user.uid)
          .get();

      setState(() {
        ticketCount = ticketsSnapshot.size;
      });
    } catch (e) {
      debugPrint('Error fetching ticket count: $e');
    }
  }

  Future<void> _fetchPendingRequestCount() async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    try {
      final QuerySnapshot requestsSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('sentRequests')
          .where('status', isEqualTo: 'pending')
          .get();

      setState(() {
        pendingRequestCount = requestsSnapshot.size;
      });
    } catch (e) {
      debugPrint('Error fetching pending request count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);

    return BlocConsumer<AuthCubit, AuthState>(
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
        return SafeArea(
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).colorScheme.surface,
              elevation: 0,
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.edit, color: AppColors().orange),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmpProfileEditPage(),
                      ),
                    ).then((_) => _fetchEmployeeData());
                  },
                ),
              ],
            ),
            body: userData == null
                ? const ShimmerPage()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                     CircleAvatar(
  radius: 50,
  backgroundImage: _imageUrl != null
      ? NetworkImage(_imageUrl!) as ImageProvider
      : const AssetImage('lib/assets/images/teacher.jpg'),
),

                      const SizedBox(height: 10),
                      Text(
                        _nameController.text,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text(
                        _emailController.text,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors().grey,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            StatItem(
                                label: 'Orders \n Completed',
                                value: orderCount.toString()),
                            StatItem(
                                label: 'Tickets',
                                value: ticketCount.toString()),
                            StatItem(
                                label: 'Pending \n Requests',
                                value: pendingRequestCount.toString()),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              EmpBuildMenuContainer(
                                title: 'Profile',
                                icon: Icons.person,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.empProfileInfoPage,
                                  );
                                },
                              ),
                              EmpBuildMenuContainer(
                                title: 'Contact us',
                                icon: Icons.contact_page,
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.contactUsPage);
                                },
                              ),
                              EmpBuildMenuContainer(
                                title: 'Delete Account',
                                icon: Icons.info,
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      AppRoutes.empaccountDeletionScreen);
                                },
                              ),
                              EmpBuildMenuContainer(
                                title: 'Settings',
                                icon: Icons.settings,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SettingsPage(),
                                    ),
                                  );
                                },
                              ),
                              EmpBuildMenuContainer(
                                title: 'Logout',
                                icon: Icons.logout,
                                onTap: () async {
                                  await authCubit.signOut(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}