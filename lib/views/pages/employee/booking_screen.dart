import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/widgets/employee/active_booking_tab.dart';
import 'package:hire_harmony/views/widgets/employee/booking_history_tab.dart';
import 'package:hire_harmony/views/widgets/employee/new_requests_tap.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // عدد التبويبات
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).colorScheme.primary),
            onPressed: () {
              Navigator.pop(context);
              // الرجوع للخلف
            },
          ),
          title: Text(
            'Booking',
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary, fontSize: 18),
          ),
          bottom: TabBar(
            dividerColor: AppColors().transparent,
            labelColor: AppColors().orange,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors().orange,
            labelStyle: const TextStyle(
              fontSize: 16, // Text size for selected tabs
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14, // Text size for unselected tabs
              fontWeight: FontWeight.normal,
            ),
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



