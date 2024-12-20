import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/view_models/cubit/adnhome_cubit.dart';
import 'package:hire_harmony/views/widgets/admin/notification_item.dart';

class AdnNotificationsPage extends StatefulWidget {
  const AdnNotificationsPage({super.key});

  @override
  State<AdnNotificationsPage> createState() => _AdnNotificationsPageState();
}

class _AdnNotificationsPageState extends State<AdnNotificationsPage> {
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AdnHomeCubit>(context).loadData();
    // _listenToFirebaseMessages();
    _getFCMToken();
    _loadNotifications();
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      saveFCMToken(newToken);
      // Listen for notification taps when the app is in the background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print("Notification clicked!");
        // Handle navigation or data processing here
      });

      // Handle notifications when the app launches from a terminated state
      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          print(
              "App launched from notification: ${message.notification?.title}");
          // Handle navigation or data processing here
        }
      });
    });
  }

  Future<void> _getFCMToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Get the FCM token
    String? token = await messaging.getToken();
    print("FCM Token: $token");

    // Save the token to the backend or Firestore
    await saveFCMToken(token);
  }

  Future<void> saveFCMToken(String? token) async {
    if (token != null) {
      // Save the token to Firestore or your backend
      await FirebaseFirestore.instance
          .collection('users')
          .doc('user_id') // Replace with the actual user ID
          .update({'fcmToken': token});
    }
  }

  // Future<void> _listenToFirebaseMessages() async {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  //     if (message.notification != null) {
  //       final userId = FirebaseAuth.instance.currentUser?.uid;
  //       if (userId == null) return;

  //       // Save the notification in Firestore for the specific user
  //       await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(userId)
  //           .collection('notifications')
  //           .add({
  //         'title': message.notification!.title ?? 'No Title',
  //         'body': message.notification!.body ?? 'No Body',
  //         'timestamp': Timestamp.now(),
  //         'read': false, // Default to unread
  //       });

  //       setState(() {
  //         notifications.add({
  //           'title': message.notification!.title ?? 'No Title',
  //           'body': message.notification!.body ?? 'No Body',
  //           'time': 'Just now',
  //           'read': false,
  //         });
  //       });
  //     }
  //   });
  // }

  // Future<void> markNotificationsAsRead() async {
  //   final userId = FirebaseAuth.instance.currentUser?.uid;
  //   if (userId == null) return;

  //   final batch = FirebaseFirestore.instance.batch();

  //   for (var notif in notifications) {
  //     final docRef = FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userId)
  //         .collection('notifications')
  //         .doc(notif['id']);
  //     batch.update(docRef, {'read': true});
  //   }

  //   await batch.commit();

  //   // Reset unread notifications
  //   // ignore: use_build_context_synchronously
  //   BlocProvider.of<AdnHomeCubit>(context).resetUnreadNotifications();
  // }

  Future<void> _loadNotifications() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        notifications = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'title': doc['title'] ?? 'No Title',
            'body': doc['body'] ?? 'No Body',
            'read': doc['read'] ?? false,
            'time': doc['timestamp'].toDate().toString(),
          };
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors().transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: AppColors().white,
              size: 25,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        centerTitle: true,
        title: Text(
          'NOTIFICATIONS',
          style: GoogleFonts.montserratAlternates(
            color: AppColors().white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/images/notf.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: AppColors().navy.withValues(alpha: 0.3),
              ),
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  NotificationItem.fromFirebase(notifications[index]),
                  const NotificationDivider(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
