// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   String? mtoken = "";
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   TextEditingController username = TextEditingController();
//   TextEditingController title = TextEditingController();
//   TextEditingController body = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     requestPermission();
//     getToken();
//     initInfo();
//   }

//   void requestPermission() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;

//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print('User granted provisional permission');
//     } else {
//       print('User declined or has not accepted permission');
//     }
//   }

//   void getToken() async {
//     await FirebaseMessaging.instance.getToken().then((token) {
//       setState(() {
//         mtoken = token;
//         print("FCM Token: $mtoken");
//       });
//       saveToken(token!);
//     }).catchError((e) {
//       print("Error getting token: $e");
//     });
//   }

//   void saveToken(String token) async {
//     String currentUserId =
//         FirebaseAuth.instance.currentUser!.uid; // Get User ID
//     await FirebaseFirestore.instance
//         .collection("users")
//         .doc(currentUserId)
//         .collection('UserTokens')
//         .doc()
//         .set({
//       'token': token,
//     }, SetOptions(merge: true)); // Save or update token
//   }

//   void sendPushMessage(String token, String body, String title) async {
//     try {
//       await http.post(
//         Uri.parse('https://fcm.googleapis.com/fcm/send'),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'key=AIzaSyCw9-raxYmhw7Y5WtPAYPgkzLvIxeJyNrc',
//         },
//         body: jsonEncode(<String, dynamic>{
//           'priority': 'high',
//           'data': <String, dynamic>{
//             'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//             'status': 'done',
//             'body': body,
//             'title': title,
//           },
//           'notification': <String, dynamic>{
//             'title': title,
//             'body': body,
//             'android_channel_id': 'dbfood',
//           },
//           'to': token,
//         }),
//       );
//     } catch (e) {
//       if (kDebugMode) {
//         print("Error push notification: $e");
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     String currentUserId = FirebaseAuth.instance.currentUser!.uid;
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextFormField(
//               controller: username,
//               decoration: const InputDecoration(labelText: 'Username'),
//             ),
//             TextFormField(
//               controller: title,
//               decoration: const InputDecoration(labelText: 'Title'),
//             ),
//             TextFormField(
//               controller: body,
//               decoration: const InputDecoration(labelText: 'Body'),
//             ),
//             GestureDetector(
//               onTap: () async {
//                 String name = username.text.trim();
//                 String titleText = title.text;
//                 String bodyText = body.text;

//                 if (name != "") {
//                   DocumentSnapshot snap = await FirebaseFirestore.instance
//                       .collection('users')
//                       .doc(currentUserId)
//                       .collection("UserTokens")
//                       .doc(name)
//                       .get();

//                   String token = snap['token'];
//                   print(token);
//                   sendPushMessage(token, bodyText, titleText);
//                 }
//               },
//               child: Container(
//                 margin: const EdgeInsets.all(20),
//                 height: 40,
//                 width: 200,
//                 color: Colors.blue,
//                 child: const Center(
//                   child: Text(
//                     "Send Notification",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void initInfo() {
//     var androidInitialize =
//         const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iosInitialize = const DarwinInitializationSettings();
//     var initializationSettings = InitializationSettings(
//       android: androidInitialize,
//       iOS: iosInitialize,
//     );

//     flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse:
//           (NotificationResponse notificationResponse) async {
//         try {
//           if (notificationResponse.payload != null &&
//               notificationResponse.payload!.isNotEmpty) {
//             print("Notification payload: ${notificationResponse.payload}");
//           }
//         } catch (e) {
//           print("Error handling notification response: $e");
//         }
//       },
//     );

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       print("Received a message while in foreground");
//       print("Message data: ${message.data}");

//       if (message.notification != null) {
//         print("Message contains a notification: ${message.notification}");

//         BigTextStyleInformation bigTextStyleInformation =
//             BigTextStyleInformation(
//           message.notification!.body ?? '',
//           contentTitle: message.notification!.title,
//         );

//         AndroidNotificationDetails androidNotificationDetails =
//             AndroidNotificationDetails(
//           'dbfood',
//           'dbfood',
//           importance: Importance.max,
//           styleInformation: bigTextStyleInformation,
//           priority: Priority.high,
//           playSound: true,
//         );

//         NotificationDetails platformChannelSpecifics = NotificationDetails(
//           android: androidNotificationDetails,
//           iOS: const DarwinNotificationDetails(),
//         );

//         await flutterLocalNotificationsPlugin.show(
//           0,
//           message.notification!.title,
//           message.notification!.body,
//           platformChannelSpecifics,
//           payload: message.data['payload'],
//         );
//       }
//     });
//   }
// }
