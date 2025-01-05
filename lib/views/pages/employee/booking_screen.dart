import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';

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
class NewRequestsTab extends StatelessWidget {
  const NewRequestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3, // Replace with your data count
        itemBuilder: (context, index) {
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
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150'), // Replace with your image URL
                    radius: 30,
                  ),
                  const SizedBox(width: 16),
                  // Details
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alice Henry requested you for Flower delivery services.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
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
                          // Handle accept
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
                          style:
                              TextStyle(fontSize: 12, color: AppColors().white),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          // Handle cancel
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
                          style:
                              TextStyle(fontSize: 12, color: AppColors().black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    //هاي في حالة لو فش طلبات بنعرضو
    /*  Center(
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
    );*/
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
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/150'),
                  radius: 30,
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Your active booking for Flower delivery.',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // إلغاء الحجز
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
                    style: TextStyle(fontSize: 12, color: AppColors().black),
                  ),
                ),
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
