import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/services/employee_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:intl/intl.dart';

class EmpOrderPage extends StatefulWidget {
  const EmpOrderPage({super.key});

  @override
  State<EmpOrderPage> createState() => _EmpOrderPageState();
}

class _EmpOrderPageState extends State<EmpOrderPage> {
  final EmployeeService _employeeService = EmployeeService();
  String? loggedInUserId; // ✅ تعديل المتغير ليصبح قابلًا لأن يكون `null`

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  // ✅ جلب `userId` عند تحميل الصفحة
  void _initializeUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        loggedInUserId = user.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loggedInUserId == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Orders',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'Orders',
            style: GoogleFonts.montserratAlternates(
              fontSize: 22,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            dividerColor: AppColors().transparent,
            labelColor: AppColors().orange,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors().orange,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            tabs: const [
              Tab(text: 'In Progress'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrdersTab(loggedInUserId!, 'in progress'),
            _buildOrdersTab(loggedInUserId!, 'completed'),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersTab(String userId, String status) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _employeeService.fetchOrders(userId, status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error fetching $status orders. Please try again later.',
              style: GoogleFonts.montserratAlternates(
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        final orders = snapshot.data ?? [];

        if (orders.isEmpty) {
          return Center(
            child: Text(
              'No $status orders found.',
              style: GoogleFonts.montserratAlternates(
                fontSize: 18,
                color: AppColors().grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            final orderId = order['id'];
            final customerId = order['senderId'];
            final orderName = order['name'];
            final orderStatus = order['status'];
            final formattedTime =
                DateFormat.jm().format(order['confirmedTime']);
            final formattedDate =
                DateFormat.yMMMMd().format(order['confirmedTime']);
            final customerImage = order['customerImage'];

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(customerImage),
                ),
                title: Text(
                  orderName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Order ID: $orderId\n'
                    'Sent on: $formattedDate at $formattedTime'),
                trailing: Icon(
                  Icons.circle,
                  color: _getStatusColor(orderStatus),
                  size: 12,
                ),
                onTap: status == 'in progress'
                    ? () => _employeeService.showOrderDialog(
                        context, orderId, customerId, loggedInUserId!, order)
                    : null, // ✅ Disable tap for completed orders
              ),
            );
          },
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'in progress':
        return AppColors().orange;
      case 'completed':
        return AppColors().green;
      case 'assigned':
        return AppColors().navy2;
      case 'accepted':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }
}
