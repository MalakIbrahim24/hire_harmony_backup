import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hire_harmony/utils/route/app_routes.dart';
import 'package:hire_harmony/view_models/cubit/auth_cubit.dart';
import 'package:hire_harmony/views/pages/admin/admin_activity_page.dart';
import 'package:hire_harmony/views/pages/admin/admin_settings_page.dart';
import 'package:hire_harmony/views/pages/admin/adn_home_page.dart';
import 'package:hire_harmony/views/pages/admin/adn_navbar.dart';
import 'package:hire_harmony/views/pages/admin/adn_notifications_page.dart';
import 'package:hire_harmony/views/pages/admin/adn_personal_info_page.dart';
import 'package:hire_harmony/views/pages/customer/cus_home_page.dart';
import 'package:hire_harmony/views/pages/employee/emp_home_page.dart';
import 'package:hire_harmony/views/pages/login/login_page.dart';
import 'package:hire_harmony/views/pages/signup/signIn_page.dart';
import 'package:hire_harmony/views/pages/signup/sign_up_choice.dart';
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
      case AppRoutes.adnnpersonalinfoPage:
        return MaterialPageRoute(
          builder: (_) => const AdnPersonalInfoPage(),
          settings: settings,
        );
      case AppRoutes.signupChoicePage:
        return MaterialPageRoute(
          builder: (_) => const SignUpChoice(),
          settings: settings,
        );
      case AppRoutes.adnsettingsPage:
        return MaterialPageRoute(
          builder: (_) => const AdminSettingsPage(),
          settings: settings,
        );
      case AppRoutes.adnnotificationsPage:
        return MaterialPageRoute(
          builder: (_) => const AdnNotificationsPage(),
          settings: settings,
        );
      case AppRoutes.adnactivityPage:
        return MaterialPageRoute(
          builder: (_) =>
              AdminActivityPage(uid: FirebaseAuth.instance.currentUser!.uid),
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
