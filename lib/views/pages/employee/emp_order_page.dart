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

  Future<String?> _fetchEmployeeState(String userId) async {
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return userDoc['state'] as String?;
      }
    } catch (e) {
      debugPrint("Error fetching employee state: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final String? loggedInUserId = FirebaseAuth.instance.currentUser?.uid;

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
          child: Text('User not logged in'),
        ),
      );
    }

    return FutureBuilder<String?>(
      future: _fetchEmployeeState(loggedInUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
            ),
            extendBodyBehindAppBar: true,
            body: Center(
              child: Text(
                'Error loading data. Please try again later.',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserratAlternates(
                  fontSize: 18,
                  color: AppColors().navy,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        } else if (snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors().transparent,
            ),
            extendBodyBehindAppBar: true,
            body: Center(
              child: Text(
                'No orders found.',
                style: GoogleFonts.montserratAlternates(
                  fontSize: 14,
                  color: AppColors().grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }

        final String? employeeState = snapshot.data;

        if (employeeState == 'pending') {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            extendBodyBehindAppBar: true,
            body: Stack(
              children: [
                // Semi-transparent dark overlay

                Container(
                  color: Colors.black.withValues(alpha: 0.35), // Dark overlay
                ),
                // Lock icon and text in the center
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lock,
                        size: 70,
                        color: AppColors().white,
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      Text(
                        'Orders are locked for now',
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 20,
                          color: AppColors().white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Please wait until we verify your identity.',
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 16,
                          color: Colors.white, // White text for contrast
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        final Stream<List<Map<String, dynamic>>> ordersStream =
            FirestoreService.instance.collectionStream(
          path: 'users/$loggedInUserId/orders',
          builder: (data, documentId) => {
            ...data,
            'orderID': documentId,
          },
        );

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Orders',
              style: GoogleFonts.montserratAlternates(
                fontSize: 22,
                color: Theme.of(context).colorScheme.primary,
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
                      color: AppColors().grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              final orders = snapshot.data!;

              return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final sentTime = order['sentTime'] as Timestamp;
                  final formattedTime =
                      DateFormat.jm().format(sentTime.toDate());
                  final formattedDate =
                      DateFormat.yMMMMd().format(sentTime.toDate());

                  return OrderTile(
                    title: order['name'] as String? ?? 'No Title',
                    subtitle:
                        'Order ID: ${order['orderID'] as String? ?? 'N/A'}',
                    status: order['status'] as String? ?? 'Unknown',
                    statusColor:
                        _getStatusColor(order['status'] as String? ?? ''),
                    sentTime: formattedTime,
                    sentDate: formattedDate,
                  );
                },
              );
            },
          ),
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
