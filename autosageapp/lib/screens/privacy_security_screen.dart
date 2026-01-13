import 'dart:convert';
import 'package:autosageapp/screens/forget_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'privacy_policy_screen.dart';
// 1. Import the two new screens
import 'security_policy_screen.dart';


class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  // `appLockEnabled` is no longer used but can be kept for future implementation.
  bool appLockEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Security'),
      ),
      body: ListView(
        children: [
          // ================= SECURITY =================
          _buildSectionHeader('Security', context),

          // 2. REPLACED the App Lock switch with two new navigation tiles
          _buildSettingsTile(
            context: context,
            icon: Icons.security_outlined,
            title: 'Security Policy',
            subtitle: 'Learn how we protect your account',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SecurityPolicyScreen(),
                ),
              );
            },
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.lock_reset_outlined,
            title: 'Reset Password',
            subtitle: 'Update your account password',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ForgotPasswordScreen(),
                ),
              );
            },
          ),

          const Divider(),

          // ================= PRIVACY =================
          _buildSectionHeader('Privacy', context),

          _buildSettingsTile(
            context: context,
            icon: Icons.policy_outlined,
            title: 'Privacy Policy',
            subtitle: 'Read how we collect and use your data',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PrivacyPolicyScreen(),
                ),
              );
            },
          ),

          _buildSettingsTile(
            context: context,
            icon: Icons.data_usage_outlined,
            title: 'Manage Your Data',
            subtitle: 'Download or request deletion of your data',
            onTap: () => _showDataOptions(context),
          ),
        ],
      ),
    );
  }

  // ... (The rest of your file remains exactly the same)
  // ... (_buildSectionHeader, _buildSettingsTile, _showDataOptions, etc.)
  // ================= SECTION HEADER =================
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

  // ================= NORMAL TILE =================
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

  // ================= SWITCH TILE =================
  Widget _buildSwitchTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  // ================= DATA OPTIONS =================
  void _showDataOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.download),
                title: const Text('Download My Data'),
                onTap: () {
                  Navigator.pop(context);
                  _downloadUserData(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text('Request Account Deletion'),
                onTap: () {
                  Navigator.pop(context);
                  requestAccountDeletion(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= DOWNLOAD DATA =================
  Future<void> _downloadUserData(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("userId");

    if (!mounted) return;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not found")),
      );
      return;
    }

    final response = await http.get(
      Uri.parse("http://10.0.2.2:3000/api/download-data/$userId"),
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Your data has been prepared successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to download data")),
      );
    }
  }

  // ================= REQUEST DELETION =================
  Future<void> requestAccountDeletion(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("userId");

    if (!mounted) return;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    final response = await http.post(
      Uri.parse("http://10.0.2.2:3000/api/request-deletion"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId}),
    );

    if (!mounted) return;

    final data = jsonDecode(response.body);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(data["message"])),
    );
  }
}
