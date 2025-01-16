import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // عدد التبويبات
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
              // الرجوع للخلف
            },
          ),
          title: const Text(
            'Booking',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onPressed: () {
                // إجراء إضافي
              },
            ),
          ],
          bottom: TabBar(
            indicatorColor: AppColors().orange,
            indicatorWeight: 2,
            labelColor: AppColors().orange,
            unselectedLabelColor: AppColors().grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'New Requests'),
              Tab(text: 'Active Bookings'),
              Tab(text: 'Booking History'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // تبويب الطلبات الجديدة
            NewRequestsTab(),
            // تبويب الحجوزات النشطة
            ActiveBookingsTab(),
            // تبويب سجل الحجوزات
            BookingHistoryTab(),
          ],
        ),
      ),
    );
  }
}

// تبويب الطلبات الجديدة
class NewRequestsTab extends StatefulWidget {
  const NewRequestsTab({super.key});

  @override
  State<NewRequestsTab> createState() => _NewRequestsTabState();
}

class _NewRequestsTabState extends State<NewRequestsTab> {
  Future<void> _acceptRequest(String requestId, String receiverId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('sentRequests')
          .doc(requestId)
          .update({'pendingRequests': 'accepted'});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request accepted successfully!')),
      );
    } catch (e) {
      debugPrint('Error accepting request: $e');
    }
  }

  // Cancel Request
  Future<void> _cancelRequest(String requestId, String receiverId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('sentRequests')
          .doc(requestId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request canceled successfully!')),
      );
    } catch (e) {
      debugPrint('Error canceling request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the logged-in employee's UID
    final String? loggedInUserId = FirebaseAuth.instance.currentUser?.uid;

    if (loggedInUserId == null) {
      return const Center(
        child: Text(
          'User not logged in.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    // Firestore query for received requests
    final Stream<QuerySnapshot> receivedRequestsStream = FirebaseFirestore
        .instance
        .collectionGroup('Requests')
        .where('receiverId', isEqualTo: loggedInUserId)
        .where('pendingRequests',
            isEqualTo: 'pending') // Only show pending requests
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
            final description =
                request['description'] ?? 'No description provided';
            final senderName = request['name'] ?? 'Unknown Sender';
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
                    // User image
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          request['img'] ?? 'https://via.placeholder.com/150'),
                      radius: 30,
                    ),
                    const SizedBox(width: 16),
                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            senderName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Requested on $formattedDate at $formattedTime',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Buttons
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Accept request logic here
                            _acceptRequest(request.id, loggedInUserId);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors().navy,
                            minimumSize: const Size(80, 36),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Accept',
                            style: TextStyle(
                                fontSize: 12, color: AppColors().white),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            // Cancel request logic here
                            _cancelRequest(request.id, loggedInUserId);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors().lightblue,
                            minimumSize: const Size(80, 36),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                fontSize: 12, color: AppColors().black),
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
  }
}

// تبويب الحجوزات النشطة
class ActiveBookingsTab extends StatelessWidget {
  const ActiveBookingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: List.generate(3, (index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage('https://via.placeholder.com/150'),
                      radius: 30,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Your active booking for Flower delivery.',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // إلغاء الحجز
                        //remove request
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors().orangelight,
                        minimumSize: const Size(80, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: 12, color: AppColors().red),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        //update request state to in progress and move to orders page
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors().lightblue,
                        minimumSize: const Size(80, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Accept',
                        style:
                            TextStyle(fontSize: 12, color: AppColors().black),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}

// تبويب سجل الحجوزات
class BookingHistoryTab extends StatelessWidget {
  const BookingHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: List.generate(5, (index) {
        return ListTile(
          leading: const CircleAvatar(
            backgroundImage: NetworkImage(
                'https://via.placeholder.com/150'), // صورة المستخدم
          ),
          title: Text(
            'Completed booking #$index',
            style: TextStyle(
              fontSize: 15,
              color: AppColors().navy,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: const Text('Flower delivery - 25 Dec 2024'),
          trailing: Icon(Icons.check_circle, color: AppColors().navy),
        );
      }),
    );
  }
}
