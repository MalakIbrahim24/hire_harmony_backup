import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/services/firestore_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/widgets/customer/order_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Two tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fetch the current user's UID
    final String? loggedInUserId = FirebaseAuth.instance.currentUser?.uid;

    if (loggedInUserId == null) {
      return Scaffold(
        backgroundColor: AppColors().orange,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Orders',
            style: TextStyle(color: AppColors().navy),
          ),
        ),
        body: const Center(
          child: Text('User not logged in'),
        ),
      );
    }

    // Reference to the 'orders' and 'pendingRequests' subcollections
    final Stream<List<Map<String, dynamic>>> ordersStream =
        FirestoreService.instance.collectionStream(
      path: 'users/$loggedInUserId/orders',
      builder: (data, documentId) => {
        ...data,
        'orderID': documentId, // Include the document ID as orderID
      },
    );

    final Stream<List<Map<String, dynamic>>> pendingRequestsStream =
        FirestoreService.instance.collectionStream(
      path: 'users/$loggedInUserId/sentRequests',
      builder: (data, documentId) => {
        ...data,
        'requestID': documentId, // Include the document ID as requestID
      },
    );

    return Scaffold(
      backgroundColor: AppColors().white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Orders & Requests',
          style: GoogleFonts.montserratAlternates(
            fontSize: 22,
            color: AppColors().navy,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors().orange,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors().orange,
          tabs: const [
            Tab(text: 'Pending Requests'),
            Tab(text: 'Orders'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPendingRequestsTab(pendingRequestsStream),
          _buildOrdersTab(ordersStream),
        ],
      ),
    );
  }

  Widget _buildOrdersTab(Stream<List<Map<String, dynamic>>> ordersStream) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: ordersStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text(
            'No orders found.',
            style: GoogleFonts.montserratAlternates(
              fontSize: 18,
              color: AppColors().navy,
              fontWeight: FontWeight.bold,
            ),
          ));
        }

        final orders = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            final sentTime = order['sentTime'] as Timestamp?;
            final formattedTime = sentTime != null
                ? DateFormat.jm().format(sentTime.toDate())
                : 'Unknown time';
            final formattedDate = sentTime != null
                ? DateFormat.yMMMMd().format(sentTime.toDate())
                : 'Unknown date';

            return OrderTile(
              title: order['name'] as String? ?? 'No Title',
              subtitle: 'Order ID: ${order['orderID'] as String? ?? 'N/A'}',
              status: order['status'] as String? ?? 'Unknown',
              statusColor: _getStatusColor(order['status'] as String? ?? ''),
              sentTime: formattedTime,
              sentDate: formattedDate,
            );
          },
        );
      },
    );
  }

  Future<void> _deleteRequest({
    required String customerId,
    required String requestId,
    required String employeeId,
  }) async {
    try {
      // Delete from customer's collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(customerId)
          .collection('sentRequests')
          .doc(requestId)
          .delete();

      // Delete from employee's collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(employeeId)
          .collection('receivedRequests')
          .doc(requestId)
          .delete();

      // Show a success message
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request deleted successfully!')),
      );
    } catch (e) {
      debugPrint('Error deleting request: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to delete request. Please try again.')),
      );
    }
  }

  Widget _buildPendingRequestsTab(
      Stream<List<Map<String, dynamic>>> pendingRequestsStream) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: pendingRequestsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text(
            'No pending requests found.',
            style: GoogleFonts.montserratAlternates(
              fontSize: 18,
              color: AppColors().navy,
              fontWeight: FontWeight.bold,
            ),
          ));
        }

        final requests = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            final sentTime = request['sentTime'] as Timestamp?;
            final formattedTime = sentTime != null
                ? DateFormat.jm().format(sentTime.toDate())
                : 'Unknown time';
            final formattedDate = sentTime != null
                ? DateFormat.yMMMMd().format(sentTime.toDate())
                : 'Unknown date';

            return ListTile(
              title: Text(
                request['name'] as String? ?? 'No Title',
                style: GoogleFonts.montserratAlternates(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Request ID: ${request['requestID'] as String? ?? 'N/A'}\n'
                'Sent: $formattedDate at $formattedTime',
                style: GoogleFonts.montserratAlternates(fontSize: 14),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteRequest(
                  customerId: FirebaseAuth.instance.currentUser!.uid,
                  requestId: request['requestID'] as String,
                  employeeId: request['receiverId'] as String,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors().orange;
      case 'confirmed':
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
