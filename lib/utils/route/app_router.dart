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
import 'package:hire_harmony/views/pages/cus_verification_success_page.dart';
import 'package:hire_harmony/views/pages/customer/cus_home_page.dart';
import 'package:hire_harmony/views/pages/emp_verification_success_page.dart';
import 'package:hire_harmony/views/pages/employee/emp_home_page.dart';
import 'package:hire_harmony/views/pages/forgot_password_page.dart';
import 'package:hire_harmony/views/pages/forms/emp_signin_form.dart';
import 'package:hire_harmony/views/pages/login/login_page.dart';
import 'package:hire_harmony/views/pages/signup/emp_id_verification_page.dart';
import 'package:hire_harmony/views/pages/signup/emp_phone_page.dart';
import 'package:hire_harmony/views/pages/signup/emp_sign_up_page.dart';
import 'package:hire_harmony/views/pages/signup/phone_page.dart';
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
      case AppRoutes.empSigninForm:
        return MaterialPageRoute(
          builder: (_) => const EmpSigninForm(),
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
      case AppRoutes.empphonePage:
        return MaterialPageRoute(
          builder: (_) => const EmpPhonePage(),
          settings: settings,
        );
      case AppRoutes.empVerificationSuccessPage:
        return MaterialPageRoute(
          builder: (_) => const EmpVerificationSuccessPage(
              notificationTitle: 'Success!',
              notificationMessage:
                  'User verified successfully,\nShare your skills and experience with everyone!'),
          settings: settings,
        );
      case AppRoutes.empsignupPage:
        return MaterialPageRoute(
          builder: (_) => const EmpSignUpPage(),
          settings: settings,
        );
      case AppRoutes.empidverificationPage:
        return MaterialPageRoute(
          builder: (_) => const EmpIdVerificationPage(
            stepText: 'Please fill in the required information',
          ),
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
      case AppRoutes.forgotPasswordPage:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordPage(),
          settings: settings,
        );
      case AppRoutes.phonePage:
        return MaterialPageRoute(
          builder: (_) => const PhonePage(),
          settings: settings,
        );
      case AppRoutes.cusVerificationSuccessPage:
        return MaterialPageRoute(
          builder: (_) => const CusVerificationSuccessPage(
            notificationTitle: 'Phone verification success',
            notificationMessage:
                'You have successfully verified that you are using a valid phone number,\nEnjoy our services!',
          ),
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
