import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class LocalNotificationService {
  static String serverKey =
      "AAAALZIQII:APA91bGk6egqfnWFmAldyimA2l0Cw08FbmbTtALvVkH3Fwvj0GRKzKb8cFRPME";

  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void display(RemoteMessage message) async {
    try {
      print("In Notification method");
      Random random =  Random();
      int id = random.nextInt(1000);

      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "mychannel",
          "mychannel",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      print("my id is ${id.toString()}");

      await _flutterLocalNotificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
      );
    } catch (e) {
      print("Error in display notification: $e");
    }
  }

  static Future<void> sendNotification(
      {String? title, String? message, String? token}) async {
    print("\n\n\n\n\n\n");
    print("Token is $token");
    print("\n\n\n\n\n\n");

    final data = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "message": message,
    };

    try {
      http.Response r = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=ya29.c.c0ASRK0GaQWp6XXbnZOy40icUjTyA7IkbEGKcfo5FfXGOiIepSKVR7NgGinRlJP5sJKlRjbV2gRKDZIrB0jXhPadg0yDkrp8IFXd2nayCMkIauPkjiXE0NHJs7J0etH3Lb1CY3WHD1WwROaQ8Oq0lgCkuVFVchRcgu4CnjqypEKR5hLCgTnzZDH8ZX23948_OXGxOPiRYYcx0QxEpIezVcqXua1w2v1h27xD5DGu0QJtwhi_SPvv2sZDsfMupCc6EvNXQXZge-rSPjAmv86EE3kMN2vd-sBxB3b646P6lo7o3u_3jAGnQVY6oM9uVLjAj9nY4kGCgEablRfK_jKUdb0knVlbvGVz2hLofPL_oB9DpCbwU-cwO3QS4OUmsE388AiZl1lqsyfuXX_UZWkY4FyjRYh-z-oin-eiOzug3QfuguQgaRisviz7F-aqBBWgyR0c99i70qic8RBFY_nkmRtBr_gWhsoRO5qwVaV3fxvg2ldn9XsOj6-eIx1Zywiw3BzelxkiZcut_YyQ6Bzv6SbMu7rzzoi5s6O5bhWbF5VYcuIkm45BnWOyWQcs3uYwMFjuunFIw90J731-p5vxogftv55-mqnQpfz8ugvhkwIVwBpQ6Be0B_dFcWlBdfZZ407MIo0SJMep_3OScMwX1_pV9pQwk6UwVR3QrYrWldokFl2m8WWIYXvW4uOeucZzfacm3sll8fhZvZVv54ROx-_dJvmhghQF6V_wwwUzFhwq9eunrvWQ4JlSSBe1Xyomlpb9BvI82BJko00gIcIt0evay_zhMd8gOVySWrU7peIj6eZ6BRz35aY2Y66zu8xxIis9BQZXZrhW-Mzs0m-oyRhRyrIYZMl2Mse59dzOVOssUqIa3kv44aj3IlSzYvyY164reUucUm-OsZdadS3rQupfh1u0dzByQp7X4suOwuVi5aQU57Rvw1vVx8zl-d0owbge52j2I7q_yYOF5rl6jyrh20VsZrY_vU2v9ZxoQ3M',
        },
        body: jsonEncode(<String, dynamic>{
          'notification': <String, dynamic>{'body': message, 'title': title},
          'priority': 'high',
          'data': data,
          'to': token,
        }),
      );

      print(r.body);
      if (r.statusCode == 200) {
        print('Done');
      } else {
        print(r.statusCode);
      }
    } catch (e) {
      print('Exception $e');
    }
  }

  static storeToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      print(token);
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({"fcmToken": token}, SetOptions(merge: true));
    } catch (e) {
      print("Error is $e");
    }
  }
}
