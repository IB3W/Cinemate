import 'package:flutter/material.dart';
import 'package:cinamate/features/splash/screens/splash_screen.dart';
import 'package:cinamate/features/auth/screens/login_screen.dart';
import 'package:cinamate/features/auth/screens/register_screen.dart';
import 'package:cinamate/features/auth/screens/forgot_password_screen.dart';
import 'package:cinamate/features/auth/screens/verify_email_screen.dart';
import 'package:cinamate/features/navigation/screens/navigation_shell.dart';
import 'package:cinamate/features/details/screens/details_screen.dart';
import 'package:cinamate/features/home/screens/see_all_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String verifyEmail = '/verify-email';
  static const String navigationShell = '/navigation';
  static const String details = '/details';
  static const String seeAll = '/see-all';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      case verifyEmail:
        return MaterialPageRoute(builder: (_) => const VerifyEmailScreen());

      case navigationShell:
        return MaterialPageRoute(builder: (_) => const NavigationShell());

      case details:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) =>
              DetailsScreen(id: args['id'], isMovie: args['isMovie']),
        );

      case seeAll:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) =>
              SeeAllScreen(title: args['title'], items: args['items']),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
