import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hire_harmony/utils/route/app_router.dart';
import 'package:hire_harmony/utils/route/app_routes.dart';
import 'package:hire_harmony/view_models/cubit/auth_cubit.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // Create a new instance of the AuthCubit
        // and use it to return current user so we can get whatever user has entered
        final cubit = AuthCubit();
        cubit.getCurrentUser();
        return cubit;
      },
      child: Builder(
          //  This builder is used to get the context of the MaterialApp
          //   and then use it to give the bloc builder
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
            }
            return MaterialApp(
              title: 'Hire Harmony',
              initialRoute: initRoute,
              onGenerateRoute: AppRouter.onGenerateRoute,
            );
          },
        );
      }),
    );
  }
}
