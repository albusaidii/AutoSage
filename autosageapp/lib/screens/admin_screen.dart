import 'package:autosageapp/screens/admin_feedback_screen.dart';
import 'package:autosageapp/screens/send_notificaitons_screen.dart';
import 'package:flutter/material.dart';
import 'admin_garage_management_screen.dart';
import 'admin_reports_screen.dart';
import 'app_settings_screen.dart';
import 'login_screen.dart';
// 1. IMPORT THE NEW SCREEN
import 'admin_user_management_screen.dart';

// --- Main Admin Screen (Dashboard) ---
class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        // Optional: Add a logout action
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Header Section
          _buildHeader(context),
          const SizedBox(height: 24),

          // Grid of Admin Actions
          _buildAdminActionGrid(context),
        ],
      ),
    );
  }

  // --- Builder Widgets ---

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome, Admin!',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Manage users, content, and system settings.',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildAdminActionGrid(BuildContext context) {
    // Define the actions available to the admin
    final List<_AdminAction> actions = [
      _AdminAction(
        title: 'User Management',
        icon: Icons.people_outline,
        color: Colors.blue,
        onTap: () {
          // 2. NAVIGATE TO THE NEW SCREEN
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AdminUserManagementScreen()),
          );
        },
      ),
      _AdminAction(
        title: 'Garage Management',
        icon: Icons.store_mall_directory_outlined,
        color: Colors.orange,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AdminGarageManagementScreen()),
          );
        },
      ),
      _AdminAction(
        title: 'View Reports',
        icon: Icons.bar_chart_outlined,
        color: Colors.green,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AdminReportsScreen()),
          );
        },
      ),
      _AdminAction(
        title: 'App Settings',
        icon: Icons.settings_outlined,
        color: Colors.purple,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AppSettingsScreen()),
          );
        },
      ),
      _AdminAction(
        title: 'Send Notifications',
        icon: Icons.send_outlined,
        color: Colors.red,
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SendNotificationsScreen()),
          );
        },
      ),
      _AdminAction(
        title: 'View Feedback',
        icon: Icons.feedback_outlined,
        color: Colors.teal,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AdminFeedbackScreen()),
          );
        },
      ),
    ];

    return GridView.builder(
      shrinkWrap: true, // Important for GridView inside a ListView
      physics: const NeverScrollableScrollPhysics(), // The ListView will handle scrolling
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two cards per row
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1, // Adjust for desired card height
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return _AdminActionCard(action: action);
      },
    );
  }
}

// --- Helper Widgets and Data Models ---

/// A data model for an admin action.
class _AdminAction {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _AdminAction({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

/// A reusable card widget for displaying an admin action.
class _AdminActionCard extends StatelessWidget {
  final _AdminAction action;

  const _AdminActionCard({required this.action});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: action.onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon with colored background
              CircleAvatar(
                radius: 24,
                backgroundColor: action.color.withOpacity(isDark ? 0.3 : 0.15),
                child: Icon(action.icon, color: action.color, size: 28),
              ),
              const Spacer(),
              // Title text
              Text(
                action.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

