import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cinamate/core/theme/app_theme.dart';
import 'package:cinamate/providers/auth_provider.dart';
import 'package:cinamate/config/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);

    // Choose route based on auth state
    String nextRoute = AppRoutes.login;
    if (auth.isAuthenticated) {
      nextRoute = auth.isEmailVerified
          ? AppRoutes.navigationShell
          : AppRoutes.verifyEmail;
    }

    Navigator.pushReplacementNamed(context, nextRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Logo
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: AppTheme.primary.withValues(alpha: 0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withValues(alpha: 0.15),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.movie_filter,
                    color: AppTheme.primary,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Cinamate',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'TRACK. WATCH. DISCOVER.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          // Footer
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: Text(
                'Version 0.1',
                style: TextStyle(color: Colors.white24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
