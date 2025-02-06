import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/pages/chatePage.dart';
import 'package:intl/intl.dart';
// تبويب الطلبات الجديدة
// New Requests Tab
class NewRequestsTab extends StatefulWidget {
  const NewRequestsTab({super.key});

  @override
  State<NewRequestsTab> createState() => _NewRequestsTabState();
}

class _NewRequestsTabState extends State<NewRequestsTab> {
  Future<void> _acceptRequest(String requestId, String receiverId) async {
    try {
      // Fetch the request data to get senderId
      final requestDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('recievedRequests')
          .doc(requestId)
          .get();

      if (!requestDoc.exists) {
        throw Exception('Request does not exist.');
      }

      final data = requestDoc.data() as Map<String, dynamic>;
      final senderId = data['senderId'];

      // Get sender's info
      final senderDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .get();

      if (!senderDoc.exists) {
        throw Exception('Sender does not exist.');
      }

      final senderData = senderDoc.data() as Map<String, dynamic>;
      final senderEmail = senderData['email'];
      final senderName = senderData['name'];

      // Generate chatRoomID in a consistent order
      final chatRoomID = receiverId.compareTo(senderId) < 0
          ? '${receiverId}_$senderId'
          : '${senderId}_$receiverId';

      // Update status to "active" in both collections
      await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('recievedRequests')
          .doc(requestId)
          .update({'status': 'active'});

      await FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .collection('sentRequests')
          .doc(requestId)
          .update({'status': 'active'});

      // Check if a chat room exists
      final chatRoomDoc = await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(chatRoomID)
          .get();

      if (chatRoomDoc.exists) {
        // If chat room exists, update chatController
        await FirebaseFirestore.instance
            .collection('chat_rooms')
            .doc(chatRoomID)
            .update({'chatController': 'open'});
      } else {
        // If no chat room exists, create a new one
        await FirebaseFirestore.instance
            .collection('chat_rooms')
            .doc(chatRoomID)
            .set({
          'participants': [receiverId, senderId],
          'chatController': 'open',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request accepted successfully!')),
      );

      // Navigate to the chat room
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Chatepage(
            reciverEmail: senderEmail,
            reciverID: senderId,
            reciverName: senderName,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error accepting request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error accepting request: $e')),
      );
    }
  }

  Future<void> _cancelRequest(String requestId, String receiverId) async {
    try {
      // Fetch request to get senderId
      final requestDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('recievedRequests')
          .doc(requestId)
          .get();

      if (!requestDoc.exists) {
        throw Exception('Request does not exist.');
      }

      final senderId = requestDoc['senderId'];

      // Delete request from both collections
      await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('recievedRequests')
          .doc(requestId)
          .delete();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .collection('sentRequests')
          .doc(requestId)
          .delete();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request canceled successfully!')),
      );
    } catch (e) {
      debugPrint('Error canceling request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error canceling request: $e')),
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

    final Stream<QuerySnapshot> receivedRequestsStream = FirebaseFirestore
        .instance
        .collection('users')
        .doc(loggedInUserId)
        .collection('recievedRequests')
        .where('status', isEqualTo: 'pending')
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: receivedRequestsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.new_releases, size: 100, color: AppColors().orange),
                const SizedBox(height: 16),
                const Text(
                  'No new requests found!',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final requests = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            final senderId = request['senderId'];

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
                final senderName = userDoc['name'] ?? 'Unknown Sender';
                final description =
                    request['description'] ?? 'No description provided';
                final timestamp = request['timestamp'] as Timestamp?;
                final formattedTime = timestamp != null
                    ? DateFormat.jm().format(timestamp.toDate())
                    : 'Unknown time';
                final formattedDate = timestamp != null
                    ? DateFormat.yMMMMd().format(timestamp.toDate())
                    : 'Unknown date';

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
                                senderName,
                                style:  GoogleFonts.montserratAlternates(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.primary,
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
                                'Requested on $formattedDate at $formattedTime',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () => _acceptRequest(
                                request.id,
                                loggedInUserId,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors().navy,
                                minimumSize: const Size(80, 36),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text('Accept',
                                  style: TextStyle(color: AppColors().white)),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => _cancelRequest(
                                request.id,
                                loggedInUserId,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors().red,
                                minimumSize: const Size(80, 36),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text('Cancel',
                                  style: TextStyle(color: AppColors().white)),
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
