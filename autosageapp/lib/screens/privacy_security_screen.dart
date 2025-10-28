import 'package:flutter/material.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Security'),
      ),
      body: ListView(
        children: [
          // --- SECURITY SECTION ---
          _buildSectionHeader('Security', context),
          _buildSettingsTile(
            context: context,
            icon: Icons.password_outlined,
            title: 'Change Password',
            subtitle: 'Update your login password',
            onTap: () {
              // TODO: Navigate to a dedicated "Change Password" screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigate to Change Password')),
              );
            },
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.phonelink_lock_outlined,
            title: 'Two-Factor Authentication',
            subtitle: 'Add an extra layer of security to your account',
            onTap: () {
              // TODO: Navigate to 2FA setup screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigate to 2FA Setup')),
              );
            },
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.devices_other_outlined,
            title: 'Manage Devices',
            subtitle: 'Review devices that are logged into your account',
            onTap: () {
              // TODO: Navigate to a screen showing logged-in sessions
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigate to Manage Devices')),
              );
            },
          ),

          const Divider(),

          // --- PRIVACY SECTION ---
          _buildSectionHeader('Privacy', context),
          _buildSettingsTile(
            context: context,
            icon: Icons.policy_outlined,
            title: 'Privacy Policy',
            subtitle: 'Read how we collect and use your data',
            onTap: () {
              // TODO: Open a URL or show a dialog with the privacy policy
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening Privacy Policy')),
              );
            },
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.data_usage_outlined,
            title: 'Manage Your Data',
            subtitle: 'Download or request deletion of your account data',
            onTap: () {
              // TODO: Navigate to a data management screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigate to Data Management')),
              );
            },
          ),
        ],
      ),
    );
  }

  // Helper widget for section headers
  Widget _buildSectionHeader(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  // Helper widget for tappable tiles
  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }
}
