import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hire_harmony/api/firebase_api.dart';
import 'package:hire_harmony/api/notification_screen.dart';
import 'package:hire_harmony/services/employee/cubit/employee_cubit.dart';
import 'package:hire_harmony/src/controller/location_controller.dart';
import 'package:hire_harmony/utils/route/app_router.dart';
import 'package:hire_harmony/utils/route/app_routes.dart';
import 'package:hire_harmony/utils/theme_provider.dart';
import 'package:hire_harmony/view_models/cubit/auth_cubit.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

Future<String?> getFCMToken() async {
  await Firebase.initializeApp(); // تأكد من تهيئة Firebase

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // الحصول على الـ FCM Token
  String? token = await messaging.getToken();
  debugPrint(token.toString());
  return token;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await supabase.Supabase.initialize(
    url: 'https://ntqgtfkiyevttllyyecq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im50cWd0ZmtpeWV2dHRsbHl5ZWNxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYxNTQzNDIsImV4cCI6MjA1MTczMDM0Mn0.7APvbYoT5BpkmV1goMLIzJ7Ys2pehlns-hCO5f1oIFU',
  );

  await FirebaseApi().initNotifications();
  Get.put(LocationController());
// ✅ **تفعيل التخزين المؤقت Firestore لتقليل استهلاك القراءات**
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true, // ✅ حفظ البيانات محليًا
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED, // ✅ عدم تحديد حد للتخزين
  );
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          // create: (context) => AuthCubit(),
          create: (context) => AuthCubit()..getCurrentUser(),
        ),
        BlocProvider<EmployeeCubit>(
          create: (context) => EmployeeCubit(), // ✅ إضافة EmployeeCubit
        ),
      ],
      child: Builder(
        builder: (context) {
          final cubit = BlocProvider.of<AuthCubit>(context);
          return BlocBuilder<AuthCubit, AuthState>(
            bloc: cubit,
            buildWhen: (previous, current) =>
                current is AuthInitial ||
                current is AuthCusInitial ||
                current is AuthEmpInitial ||
                current is AuthSuccess ||
                current is AuthCusSuccess ||
                current is AuthEmpSuccess,
            builder: (context, state) {
              final String initRoute;
              if (state is AuthSuccess) {
                initRoute = AppRoutes.adnnavPage;
              } else if (state is AuthCusSuccess) {
                initRoute = AppRoutes.cushomePage;
              } else if (state is AuthEmpSuccess) {
                initRoute = AppRoutes.emphomePage;
              } else {
                initRoute = AppRoutes.welcomePage;
                log(initRoute);
              }
              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Hire Harmony',
                navigatorKey: navigatorKey,
                routes: {
                  NotificationScreen.route: (context) =>
                      const NotificationScreen(),
                },
                initialRoute: initRoute,
                onGenerateRoute: AppRouter.onGenerateRoute,
                theme: Provider.of<ThemeProvider>(context).themeData,
              );
            },
          );
        },
      ),
    );
  }
}
