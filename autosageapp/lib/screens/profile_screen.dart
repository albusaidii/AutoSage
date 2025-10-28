import 'package:autosageapp/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:autosageapp/screens/login_screen.dart';

import 'edit_profile.dart';
import 'help_support_screen.dart';
import 'notifications_screen.dart'; // Make sure this import is correct

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use the theme's background color
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue, // Or your primary theme color
        automaticallyImplyLeading: false, // Hide back button on a main screen
      ),
      body: ListView(
        children: [
          // HEADER SECTION
          const UserAccountsDrawerHeader(
            accountName: Text(
              "Sheldon Cooper",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            accountEmail: Text("sheldon.cooper@caltech.edu"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://i.pinimg.com/736x/1b/62/22/1b6222355866184a5699b350f29a73e4.jpg"),
            ),
            decoration: BoxDecoration(
              color: Colors.blue, // Match with AppBar color
            ),
          ),

          // MENU SECTION
          _buildProfileMenu(context),
        ],
      ),
    );
  }

  // Extracted widget for the profile menu to keep the build method clean
  Widget _buildProfileMenu(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ProfileMenuItem(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            onTap: () {
              // Navigate to the EditProfileScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileScreen()),
              );
            },
          ),
          ProfileMenuItem(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () {
              // Navigate to the SettingsScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          ProfileMenuItem(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationScreen()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigate to Notifications')),
              );
            },
          ),
          const Divider(),
          ProfileMenuItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              // 2. Navigate to HelpSupportScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
              );
            },
          ),
          ProfileMenuItem(
            icon: Icons.logout,
            title: 'Logout',
            textColor: Colors.red, // Make logout text stand out
            onTap: () {
              // Navigate to LoginScreen and remove all previous routes
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

// A reusable widget for menu items to avoid code duplication
class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Theme.of(context).iconTheme.color),
      title: Text(
        title,
        style: TextStyle(color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
