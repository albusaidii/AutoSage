import 'package:autosageapp/screens/privacy_security_screen.dart';
import 'package:flutter/material.dart';

import 'edit_profile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // State variables for the settings
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  String _theme = 'System';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Section for Account Settings
          _buildSectionHeader('Account'),
          _buildSettingsTile(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            subtitle: 'Update your name, email, and password',
            onTap: () {
              // Navigate to the EditProfileScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileScreen()),
              );
            },
          ),
          // ... inside the build method

          _buildSettingsTile(
            icon: Icons.lock_outline,
            title: 'Privacy & Security',
            subtitle: 'Manage your data and account security',
            onTap: () {
              // Navigate to the PrivacySecurityScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacySecurityScreen()),
              );
            },
          ),

          // ...


          const Divider(),

          // Section for Notifications
          _buildSectionHeader('Notifications'),
          _buildSwitchTile(
            title: 'Push Notifications',
            subtitle: 'Receive alerts from the app',
            value: _pushNotifications,
            onChanged: (value) {
              setState(() {
                _pushNotifications = value;
              });
            },
          ),
          _buildSwitchTile(
            title: 'Email Notifications',
            subtitle: 'Receive summaries and alerts via email',
            value: _emailNotifications,
            onChanged: (value) {
              setState(() {
                _emailNotifications = value;
              });
            },
          ),

          const Divider(),

          // Section for Appearance
          _buildSectionHeader('Appearance'),
          _buildDropdownTile(
            title: 'Theme',
            value: _theme,
            items: ['Light', 'Dark', 'System'],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _theme = value;
                });
                // TODO: Add logic to change the app's theme
              }
            },
          ),
        ],
      ),
    );
  }

  // Helper widget for section headers
  Widget _buildSectionHeader(String title) {
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

  // Helper widget for standard tappable tiles
  Widget _buildSettingsTile({
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

  // Helper widget for switch tiles
  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: Theme.of(context).primaryColor,
    );
  }

  // Helper widget for dropdown tiles
  Widget _buildDropdownTile({
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      trailing: DropdownButton<String>(
        value: value,
        underline: Container(), // Hides the default underline
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
