import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Introduction
            Text(
              'Privacy Policy for AutoSage',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 16),
            const Text(
              'Your privacy is important to us. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application, AutoSage.',
            ),
            const SizedBox(height: 24),

            // Section 1: Information We Collect
            _buildSectionTitle('1. Information We Collect', theme),
            const SizedBox(height: 12),
            _buildSubSectionTitle('a. Personal Data', theme),
            const Text(
              'While using our Service, we may ask you to provide us with certain personally identifiable information that can be used to contact or identify you. This includes, but is not limited to:\n'
                  '• Full Name\n'
                  '• Email Address',
            ),
            const SizedBox(height: 12),
            _buildSubSectionTitle('b. Usage Data', theme),
            const Text(
              'We may also collect information that your device sends whenever you use our application. This Usage Data may include information such as your device\'s IP address, device type, operating system version, the time and date of your use, and other diagnostic data.',
            ),
            const SizedBox(height: 24),

            // Section 2: How We Use Your Data
            _buildSectionTitle('2. How We Use Your Data', theme),
            const SizedBox(height: 12),
            const Text(
              'We use the collected data for various purposes:\n'
                  '• To provide and maintain our Service.\n'
                  '• To manage your account and provide you with customer support.\n'
                  '• To provide AI-driven diagnostic results based on the information you provide.\n'
                  '• To gather analysis or valuable information so that we can improve our Service.',
            ),
            const SizedBox(height: 24),

            // Section 3: Data Security
            _buildSectionTitle('3. Data Security', theme),
            const SizedBox(height: 12),
            const Text(
              'The security of your data is a priority. We use commercially acceptable means to protect your Personal Information, but remember that no method of transmission over the Internet or method of electronic storage is 100% secure.',
            ),
            const SizedBox(height: 24),

            // Section 4: Your Data Rights
            _buildSectionTitle('4. Your Data Rights', theme),
            const SizedBox(height: 12),
            const Text(
              'You have the right to access, update, or request deletion of your personal data directly within the app or by contacting us.',
            ),
            const SizedBox(height: 24),

            // Section 5: Contact Us
            _buildSectionTitle('5. Contact Us', theme),
            const SizedBox(height: 12),
            const Text(
              'If you have any questions about this Privacy Policy, please contact us at:\n'
                  '• Email: support@autosage.com', // Replace with your actual contact info
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to style section titles
  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  // Helper widget to style sub-section titles
  Widget _buildSubSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
