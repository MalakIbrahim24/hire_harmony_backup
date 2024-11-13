import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hire_harmony/services/firestore_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:intl/intl.dart';

class AdminActivityPage extends StatefulWidget {
  final String uid;
  const AdminActivityPage({super.key, required this.uid});

  @override
  State<AdminActivityPage> createState() => _AdminActivityPageState();
}

class _AdminActivityPageState extends State<AdminActivityPage> {
  final FirestoreService _firestoreService = FirestoreService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Activity Logs"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors().navy),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firestoreService.getActivityLogs(widget.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading activity logs"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No activity logs found"));
          }

          final logs = snapshot.data!;
          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              final action = log['action'] ?? 'No Action';
              final device = log['device'] ?? 'Unknown Device';
              final timestamp = (log['timestamp'] as Timestamp).toDate();
              final formattedTime =
                  DateFormat('yyyy-MM-dd HH:mm').format(timestamp);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(action),
                  subtitle: Text('Device: $device\nTime: $formattedTime'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
