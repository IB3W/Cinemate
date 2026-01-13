import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../config/routes/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.registerWithEmail(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      // Send verification email
      await authProvider.sendEmailVerification();
      if (!mounted) return;
      // Navigate to verify email screen
      Navigator.pushReplacementNamed(context, AppRoutes.verifyEmail);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Registration failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loginWithGoogle() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.loginWithGoogle();

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, AppRoutes.navigationShell);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: authProvider.isLoading
              ? null
              : () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 28),

                Center(
                  child: Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: theme.primaryColor.withValues(alpha: 0.55),
                      ),
                    ),
                    child: Icon(
                      Icons.movie_filter,
                      color: theme.primaryColor,
                      size: 34,
                    ),
                  ),
                ),
                
                SizedBox(height: 18),
                Center(
                  child: Text(
                    "Create Account",
                    style: textTheme.headlineMedium,
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: Text(
                    "Join Cinamate to track your favorite movies.",
                    style: textTheme.bodyMedium,
                  ),
                ),
                 // Full Name
                SizedBox(height: 26),

                  CustomTextField(
                  controller: _nameController,
                  hintText: "Full Name",
                  prefixIcon: Icons.person_outline,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? "Name is required" : null,
                ),

                SizedBox(height: 20),

                 // Email
                 CustomTextField(
                  controller: _emailController,
                  hintText: "Email",
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Email is required";
                    if (!v.contains("@")) return "Enter valid email";
                    return null;
                  },
                ),

                SizedBox(height: 20),

                 // Password
                CustomTextField(
                  controller: _passwordController,
                  hintText: "Password",
                  prefixIcon: Icons.lock_outline,
                  obscureText: !_showPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => _showPassword = !_showPassword),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Password is required";
                    if (v.length < 8) return "Min 8 characters";
                    return null;
                  },
                ),

                SizedBox(height: 20),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: authProvider.isLoading ? null : _register,
                    child: authProvider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(//shows a rotating circle (loading indicator).
                              color: Colors.black,
                              strokeWidth: 2, //makes the circle line thin (2px).
                            ),
                          )
                        : const Text("Sign Up"),
                  ),
                ),

                SizedBox(height: 26),

                 // Divider
                Row(
                  children: const [
                    Expanded(child: Divider(color: AppTheme.border)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "Or continue with",
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ),
                    Expanded(child: Divider(color: AppTheme.border)),
                  ],
                ),

                SizedBox(height: 16,),

                // Social Logins (Google & Apple)
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: authProvider.isLoading ? null : _loginWithGoogle,
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppTheme.cardColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.g_mobiledata,
                                color: AppTheme.textPrimary,
                              ),
                              const SizedBox(width: 10),
                              Text("Google", style: textTheme.titleMedium),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: GestureDetector(
                        onTap: authProvider.isLoading
                            ? null
                            : () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Apple Login (needs apples device support)",
                                  ),
                                ),
                              ),
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppTheme.cardColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.apple,
                                color: AppTheme.textPrimary,
                              ),
                              const SizedBox(width: 10),
                              Text("Apple", style: textTheme.titleMedium),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: authProvider.isLoading
                          ? null
                          : () => Navigator.pop(context),
                      child: Text(
                        "Log In",
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
