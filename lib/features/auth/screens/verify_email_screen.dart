import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../config/routes/app_routes.dart';
import '../../../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/loading_button.dart';
import 'dart:async';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  Timer? _timer; // timer for checking email verification
  bool _isResending = false; // for resending verification email
  @override
    void initState() {
    super.initState();
    
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.reloadUser();

      if (mounted && authProvider.isEmailVerified) {
        timer.cancel();
        // Navigate to main app
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.navigationShell,
          (route) => false,
        );
      }
    });
  }
// dispose timer to prevent memory leaks
   @override
  void dispose() {
    _timer?.cancel();
    super.dispose(); // dispose parent class
  }
// resend verification email
  Future<void> _resendVerificationEmail() async {
    setState(() => _isResending = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.sendEmailVerification();

    setState(() => _isResending = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Verification email sent!' : 'Failed to send email',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

// sign out
Future<void> _signOut() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();

    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    }
  }



@override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return  Scaffold(
      appBar: AppBar(
       actions: [
        TextButton(
          onPressed: _signOut, 
        child: Text("Sign Out",
        style: TextStyle(
          color: AppTheme.primary,
          fontWeight: FontWeight.bold,
        ),
        ))
       ],
      ), 


      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.mark_email_unread_outlined,
                  size: 50,
                  color: AppTheme.primary,
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Check your inbox',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'We\'ve sent a verification email to:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),
              Text(
                authProvider.userEmail ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Please verify your email to continue.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              ),
              SizedBox(height: 40),
              LoadingButton(
                isLoading: _isResending,
                onPressed: _resendVerificationEmail,
                text: 'Resend Email',
              ),
            ],
          ),
        ),
      ), 
    );
  }
}
