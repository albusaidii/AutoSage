import 'dart:convert';
import 'package:autosageapp/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:autosageapp/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'edit_profile.dart';
import 'help_support_screen.dart';
import 'notifications_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String baseUrl = "http://10.0.2.2:3000/api";

  String fullName = "";
  String email = "";
  int unreadNotificationsCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllUserData();
  }

  // =========================
  // LOAD USER + NOTIFICATION COUNT
  // =========================
  Future<void> _loadAllUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt("userId");

      if (userId == null) return;

      final res =
      await http.get(Uri.parse("$baseUrl/notifications/$userId"));

      int unreadCount = 0;
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        unreadCount = data.where((n) => n["is_read"] == 0).length;
      }

      if (!mounted) return;

      setState(() {
        fullName = prefs.getString("fullName") ?? "Unknown User";
        email = prefs.getString("email") ?? "No email";
        unreadNotificationsCount = unreadCount;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Profile load error: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  // =========================
  // LOGOUT
  // =========================
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0072B5),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadAllUserData,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                fullName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              accountEmail: Text(email),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person, color: Colors.grey, size: 30),
              ),
              decoration:
              const BoxDecoration(color: Color(0xFF0072B5)),
            ),
            _buildProfileMenu(context),
          ],
        ),
      ),
    );
  }

  // =========================
  // MENU
  // =========================
  Widget _buildProfileMenu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ProfileMenuItem(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
              _loadAllUserData();
            },
          ),
          ProfileMenuItem(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          ProfileMenuItem(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            unreadCount: unreadNotificationsCount,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const NotificationScreen()),
              );
              _loadAllUserData();
            },
          ),
          const Divider(),
          ProfileMenuItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const HelpSupportScreen()),
              );
            },
          ),
          ProfileMenuItem(
            icon: Icons.logout,
            title: 'Logout',
            textColor: Colors.red,
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}

// =========================
// MENU ITEM
// =========================
class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;
  final int? unreadCount;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
    this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    final hasUnread = unreadCount != null && unreadCount! > 0;

    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Row(
        children: [
          Text(title, style: TextStyle(color: textColor)),
          if (hasUnread) const SizedBox(width: 8),
          if (hasUnread)
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                unreadCount.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
