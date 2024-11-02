import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hire_harmony/utils/route/app_routes.dart';
import 'package:hire_harmony/view_models/cubit/auth_cubit.dart';
import 'package:hire_harmony/views/pages/adn_home_page.dart';
import 'package:hire_harmony/views/pages/adn_navbar.dart';
import 'package:hire_harmony/views/pages/adn_profile_info_page.dart';
import 'package:hire_harmony/views/pages/cus_home_page.dart';
import 'package:hire_harmony/views/pages/emp_home_page.dart';
import 'package:hire_harmony/views/pages/login_page.dart';
import 'package:hire_harmony/views/pages/signIn_page.dart';
import 'package:hire_harmony/views/pages/welcome_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.welcomePage:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) {
              final cubit = AuthCubit();
              return cubit;
            },
            child: const WelcomePage(),
          ),
          settings: settings,
        );
      case AppRoutes.loginPage:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
      case AppRoutes.signinPage:
        return MaterialPageRoute(
          builder: (_) => const SigninPage(),
          settings: settings,
        );
      case AppRoutes.cushomePage:
        return MaterialPageRoute(
          builder: (_) => const CusHomePage(),
          settings: settings,
        );
      case AppRoutes.emphomePage:
        return MaterialPageRoute(
          builder: (_) => const EmpHomePage(),
          settings: settings,
        );
      case AppRoutes.adnhomePage:
        return MaterialPageRoute(
          builder: (_) => const AdnHomePage(),
          settings: settings,
        );
      case AppRoutes.adnnavPage:
        return MaterialPageRoute(
          builder: (_) => const AdnNavbar(),
          settings: settings,
        );
      case AppRoutes.adnnprofileinfoPage:
        return MaterialPageRoute(
          builder: (_) => const AdnProfileInfoPage(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('NError page')),
          ),
        );
    }
  }
}
