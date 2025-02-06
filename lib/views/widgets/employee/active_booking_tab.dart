// تبويب الحجوزات النشطة
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:intl/intl.dart';
class ActiveBookingsTab extends StatelessWidget {
  const ActiveBookingsTab({super.key});

  Future<void> _confirmBooking(
      BuildContext context, DocumentSnapshot activeRequest) async {
    try {
      final String? loggedInUserId = FirebaseAuth.instance.currentUser?.uid;
      if (loggedInUserId == null) throw Exception('User not logged in.');

      final data = activeRequest.data() as Map<String, dynamic>;
      final String senderId = data['senderId'] ?? '';

      // Prepare data for the orders collection
      final orderData = {
        'name': data['name'] ?? 'Unknown',
        'orderId': activeRequest.id, // Same as request document ID
        'senderId': senderId,
        'reciverId': loggedInUserId,
        'img': data['senderImg'] ?? 'https://via.placeholder.com/150',
        'description': data['description'] ?? 'No description provided',
        'confirmedTime': FieldValue.serverTimestamp(),
        'status': 'in progress',
      };

      // Check if a chat room exists
      final chatRoomQuery = await FirebaseFirestore.instance
          .collection('chat_rooms')
          .where('participants', arrayContains: loggedInUserId)
          .get();

      DocumentReference? chatRoomRef;

// Check if the query has any documents
      if (chatRoomQuery.docs.isNotEmpty) {
        // Try to find the matching chat room
        final matchingChatRooms = chatRoomQuery.docs.where((doc) {
          final participants = doc['participants'] as List<dynamic>;
          return participants.contains(senderId) && participants.length == 2;
        }).toList();

        if (matchingChatRooms.isNotEmpty) {
          final chatRoomDoc =
              matchingChatRooms.first; // Get the first matching chat room
          chatRoomRef = FirebaseFirestore.instance
              .collection('chat_rooms')
              .doc(chatRoomDoc.id);
          await chatRoomRef.update({'chatController': 'open'});
        }
      }

// If no matching chat room is found, create a new one
      if (chatRoomRef == null) {
        chatRoomRef = FirebaseFirestore.instance.collection('chat_rooms').doc();
        await chatRoomRef.set({
          'participants': [loggedInUserId, senderId],
          'chatController': 'open',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // Update the status to "in progress" in both collections
      await FirebaseFirestore.instance
          .collection('users')
          .doc(loggedInUserId)
          .collection('recievedRequests')
          .doc(activeRequest.id)
          .update({'status': 'in progress'});

      await FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .collection('sentRequests')
          .doc(activeRequest.id)
          .update({'status': 'in progress'});

      // Add the booking to the "orders" collection of the employee
      await FirebaseFirestore.instance
          .collection('users')
          .doc(loggedInUserId)
          .collection('orders')
          .doc(activeRequest.id)
          .set(orderData);

      // Add the booking to the "orders" collection of the customer
      await FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .collection('orders')
          .doc(activeRequest.id)
          .set(orderData);

      // Add the booking to the "bookingHistory" collection of the employee
      await FirebaseFirestore.instance
          .collection('users')
          .doc(loggedInUserId)
          .collection('bookingHistory')
          .doc(activeRequest.id)
          .set(orderData);

      // Remove the request from both `sentRequests` and `recievedRequests` collections
      await FirebaseFirestore.instance
          .collection('users')
          .doc(loggedInUserId)
          .collection('recievedRequests')
          .doc(activeRequest.id)
          .delete();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .collection('sentRequests')
          .doc(activeRequest.id)
          .delete();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking confirmed successfully!')),
      );
    } catch (e) {
      debugPrint('Error confirming booking: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error confirming booking: $e')),
      );
    }
  }

  Future<void> _revokeRequest(BuildContext context,
      DocumentSnapshot activeRequest, String loggedInUserId) async {
    try {
      // Extract customer (sender) ID
      final data = activeRequest.data() as Map<String, dynamic>;
      final String senderId = data['senderId'] ?? '';

      // Query Firestore to find the correct chat room
      final chatRoomQuery = await FirebaseFirestore.instance
          .collection('chat_rooms')
          .where('participants', arrayContains: loggedInUserId)
          .get();

      // Find the chat room with the matching participants
      final chatRoomDoc = chatRoomQuery.docs.firstWhere(
        (doc) {
          final participants = doc['participants'] as List<dynamic>;
          return participants.contains(senderId) && participants.length == 2;
        },
        orElse: () => throw Exception('Chat room not found.'),
      );

      final chatRoomId = chatRoomDoc.id;

      // Update the chatController field to "closed" in the chat room
      await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(chatRoomId)
          .update({'chatController': 'closed'});

      // Delete the request document
      await activeRequest.reference.delete();
      // Delete the request from the sender's sentRequests collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .collection('sentRequests')
          .doc(activeRequest.id)
          .delete();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request revoked successfully!')),
      );
    } catch (e) {
      debugPrint('Error revoking request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error revoking request: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? loggedInUserId = FirebaseAuth.instance.currentUser?.uid;

    if (loggedInUserId == null) {
      return const Center(
        child: Text(
          'User not logged in.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    // Firestore query for active bookings
    final Stream<QuerySnapshot> activeBookingsStream = FirebaseFirestore
        .instance
        .collection('users')
        .doc(loggedInUserId)
        .collection('recievedRequests')
        .where('status', isEqualTo: 'active')
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: activeBookingsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 100, color: AppColors().orange),
                const SizedBox(height: 16),
                const Text(
                  'No active bookings found!',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final activeRequests = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: activeRequests.length,
          itemBuilder: (context, index) {
            final activeRequest = activeRequests[index];

            final data = activeRequest.data() as Map<String, dynamic>;
            final senderId = data['senderId'];

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(senderId)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage('https://via.placeholder.com/150'),
                      radius: 30,
                    ),
                    title: Text('Unknown User'),
                    subtitle: Text('No data available'),
                  );
                }

                final userDoc = snapshot.data!;
                final userImg =
                    userDoc['img'] ?? 'https://via.placeholder.com/150';
                final name = userDoc['name'] ?? 'Unknown';
                final description =
                    data['description'] ?? 'No description provided';
                final acceptedOnTimestamp =
                    data['acceptedOn'] as Timestamp? ?? Timestamp.now();
                final formattedAcceptedDate =
                    DateFormat.yMMMMd().format(acceptedOnTimestamp.toDate());
                final formattedAcceptedTime =
                    DateFormat.jm().format(acceptedOnTimestamp.toDate());

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(userImg),
                          radius: 30,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style:  GoogleFonts.montserratAlternates(
                                  color:  Theme.of(context).colorScheme.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(description,
                               style:  GoogleFonts.montserratAlternates(
                                  color:  Theme.of(context).colorScheme.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),),
                              const SizedBox(height: 4),
                              Text(
                                'Accepted on $formattedAcceptedDate at $formattedAcceptedTime',
                                style:  GoogleFonts.montserratAlternates(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () =>
                                  _confirmBooking(context, activeRequest),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors().navy,
                                minimumSize: const Size(80, 36),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Confirm',
                                style: GoogleFonts.montserratAlternates(
                                  fontSize: 12,
                                  color: AppColors().white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => _revokeRequest(
                                  context, activeRequest, loggedInUserId),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors().red,
                                minimumSize: const Size(80, 36),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Revoke',
                                style: GoogleFonts.montserratAlternates(
                                  fontSize: 12,
                                  color: AppColors().white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
