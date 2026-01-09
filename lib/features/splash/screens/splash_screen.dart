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
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Decide navigation based on auth state
    if (!authProvider.isAuthenticated) {
      // Not logged in -> go to login
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else if (!authProvider.isEmailVerified) {
      // Logged in but not verified -> go to verify email
      Navigator.pushReplacementNamed(context, AppRoutes.verifyEmail);
    } else {
      // Logged in and verified -> go to main app
      Navigator.pushReplacementNamed(context, AppRoutes.navigationShell);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Gradient
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.2),
                radius: 0.9,
                colors: [primary.withOpacity(0.1), Colors.transparent],
              ),
            ),
          ),
          // Logo & Text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: primary.withOpacity(0.35),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.18),
                      blurRadius: 18,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(Icons.movie_filter, color: primary, size: 34),
              ),
              const SizedBox(height: 18),
              Text(
                'Cinamate',
                style: theme.textTheme.headlineMedium?.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 8),
              const Text(
                'TRACK. WATCH. DISCOVER.',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.2,
                  color: Colors.white54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          // Version Footer
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: Text(
                'Version 0.1',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
