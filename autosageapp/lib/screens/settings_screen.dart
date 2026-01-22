import 'dart:convert';
import 'package:autosageapp/screens/privacy_security_screen.dart';
import 'package:autosageapp/utils/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  Future<void> _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt("userId");

    if (_userId == null) return;

    final res = await http.get(
      Uri.parse("http://10.0.2.2:3000/api/settings/notifications/$_userId"),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      setState(() {
        _pushNotifications = data["enabled"] == true;
      });
    }
  }

  Future<void> _updateNotificationPreference(bool value) async {
    if (_userId == null) return;

    setState(() => _pushNotifications = value);

    await http.put(
      Uri.parse("http://10.0.2.2:3000/api/settings/notifications/$_userId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"enabled": value}),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _buildSectionHeader('Account'),
          _buildSettingsTile(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            subtitle: 'Update your name, email, and phone',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
            },
          ),
          _buildSettingsTile(
            icon: Icons.lock_outline,
            title: 'Privacy & Security',
            subtitle: 'Manage your data and account security',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrivacySecurityScreen()),
              );
            },
          ),

          const Divider(),

          _buildSectionHeader('Notifications'),
          SwitchListTile(
            title: const Text("Receive Notifications"),
            subtitle: const Text("Allow messages from AutoSage"),
            value: _pushNotifications,
            onChanged: _updateNotificationPreference,
            activeColor: Theme.of(context).primaryColor,
          ),

          const Divider(),

          _buildSectionHeader('Appearance'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Enable dark theme'),
            value: themeNotifier.isDarkMode,
            onChanged: (_) => themeNotifier.toggleTheme(),
            secondary: Icon(
              themeNotifier.isDarkMode
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
            ),
          ),
        ],
      ),
    );
  }

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
}
