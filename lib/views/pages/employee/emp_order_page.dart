import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/services/firestore_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/widgets/customer/order_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class EmpOrderPage extends StatelessWidget {
  const EmpOrderPage({super.key});

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

    // Reference to the 'orders' subcollection for the logged-in user
    final Stream<List<Map<String, dynamic>>> ordersStream =
        FirestoreService.instance.collectionStream(
      path: 'users/$loggedInUserId/orders',
      builder: (data, documentId) => {
        ...data,
        'orderID': documentId, // Include the document ID as orderID
      },
    );

    return Scaffold(
      backgroundColor: AppColors().white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Orders',
          style: GoogleFonts.montserratAlternates(
            fontSize: 22,
            color: AppColors().navy,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
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
              final sentTime = order['sentTime'] as Timestamp;
              final formattedTime = DateFormat.jm().format(sentTime.toDate());
              final formattedDate =
                  DateFormat.yMMMMd().format(sentTime.toDate());

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
      ),
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
