import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../config/routes/app_routes.dart';
import '../../../repositories/content_repository.dart';
import '../../../data/models/content_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final repository = ContentRepository();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('My Profile'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppTheme.cardColor,
              child: Icon(Icons.person, size: 60, color: AppTheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              user?.displayName ?? 'Cinamate User',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              user?.email ?? 'No email',
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 32),

            
            Row(
              children: [
                _buildStatCard('Waitlist', repository.watchlistStream),
                const SizedBox(width: 12),
                _buildStatCard('Favorites', repository.favoritesStream),
              ],
            ),
            const SizedBox(height: 48),

          
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () => _showLogoutDialog(context, authProvider),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatCard(String label, Stream<List<ContentItem>> stream) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: StreamBuilder<List<ContentItem>>(
          stream: stream,
          builder: (context, snapshot) {
            final count = snapshot.data?.length ?? 0;
            return Column(
              children: [
                Text(
                  count.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // The Logout Popup
  void _showLogoutDialog(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text('Logout'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              auth.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
            child: const Text(
              'Yes, Logout',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
