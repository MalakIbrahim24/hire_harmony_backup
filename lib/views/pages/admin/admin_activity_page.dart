import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/services/firestore_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/widgets/admin/adn_profile_container.dart';
import 'package:intl/intl.dart';

class AdminActivityPage extends StatelessWidget {
  final String uid;
  const AdminActivityPage({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Static Header Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 80,
                ),
                Text(
                  "Activity Logs",
                  style: GoogleFonts.montserratAlternates(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 40,
                ),
                Divider(
                  thickness: 15,
                  indent: 150,
                  color: AppColors().orange.withOpacity(0.7),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),

          // StreamBuilder for Activity Logs (Scrollable Section)
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: FirestoreService.instance.getActivityLogs(uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading logs"));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No activity logs found"));
                }

                final logs = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    final action = log['action'] ?? 'Unknown Action';
                    final device = log['device'] ?? 'Unknown Device';
                    final timestamp = (log['timestamp'] as Timestamp).toDate();
                    final formattedTime =
                        DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp);

                    return AdnProfileContainer(
                      icon: Icons.access_time_outlined,
                      title: '$action \nDevice: $device \nTime: $formattedTime',
                      onTap: () {},
                      
                    );
                  },
                );
              },
            ),
          ),

          // Add Spacer and Divider at the End
          Padding(
            padding:
                const EdgeInsets.only(bottom: 50.0), // Control bottom space
            child: Divider(
              thickness: 15,
              endIndent: 150,
              color: AppColors().navy,
            ),
          ),
        ],
      ),
    );
  }
}
