import 'package:flutter/material.dart';
import '../../features/splash/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/verify_email_screen.dart';
import '../../features/navigation/screens/navigation_shell.dart';
import '../../features/details/screens/details_screen.dart';
import '../../data/models/content_item.dart';
import '../../features/home/screens/see_all_screen.dart';

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
        // Now expecting a ContentItem object directly
        final item = settings.arguments as ContentItem;
        return MaterialPageRoute(builder: (_) => DetailsScreen(item: item));

      case seeAll:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => SeeAllScreen(
            title: args['title'] as String,
            items: args['items'] as List<ContentItem>,
          ),
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
