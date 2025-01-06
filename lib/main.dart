import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hire_harmony/utils/route/app_router.dart';
import 'package:hire_harmony/utils/route/app_routes.dart';
import 'package:hire_harmony/view_models/cubit/auth_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
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
  runApp(const MyApp());
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
              return MaterialApp(
                title: 'Hire Harmony',
                initialRoute: initRoute,
                onGenerateRoute: AppRouter.onGenerateRoute,
              );
            },
          );
        },
      ),
    );
  }
}
