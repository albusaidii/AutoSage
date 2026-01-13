import 'package:flutter/material.dart';

class SecurityPolicyScreen extends StatelessWidget {
  const SecurityPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Our Commitment to Security',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Last Updated: 2024-05-21',
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            const Text(
              'At AutoSage, the security of your account and personal information is a top priority. We employ a variety of measures to ensure your data is protected against unauthorized access, alteration, and disclosure.',
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('1. Password Protection', theme),
            const SizedBox(height: 12),
            const Text(
              'Your account is protected by a password that is hashed and salted. We recommend using a strong, unique password and enabling two-factor authentication if available. Never share your password with anyone.',
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('2. Data Encryption', theme),
            const SizedBox(height: 12),
            const Text(
              'We use TLS (Transport Layer Security) encryption to protect data transmitted between your device and our servers. This ensures that your personal information, vehicle history, and communications are kept private.',
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('3. Secure Infrastructure', theme),
            const SizedBox(height: 12),
            const Text(
              'Our servers are hosted in secure, access-controlled data centers. We regularly update our systems and conduct security audits to protect against vulnerabilities.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
