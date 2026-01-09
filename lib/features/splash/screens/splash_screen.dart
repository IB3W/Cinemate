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
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else if (!authProvider.isEmailVerified) {
      Navigator.pushReplacementNamed(context, AppRoutes.verifyEmail);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.navigationShell);
    }
  }

  @override
  Widget build(BuildContext context) {
    const accent = AppTheme.primary;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.2),
                    radius: 0.9,
                    colors: [accent.withOpacity(0.10), Colors.transparent],
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      color: const Color(0xFF121826),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: accent.withOpacity(0.35),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withOpacity(0.18),
                          blurRadius: 18,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.movie_filter,
                      color: accent,
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Cinamate',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
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
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 18,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      _Dot(active: true),
                      SizedBox(width: 8),
                      _Dot(active: false),
                      SizedBox(width: 8),
                      _Dot(active: false),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Version 0.1',
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool active;
  const _Dot({required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: active ? 18 : 7,
      height: 7,
      decoration: BoxDecoration(
        color: active ? const Color(0xFFFF7A00) : Colors.white24,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}
