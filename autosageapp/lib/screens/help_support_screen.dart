import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'feedback_screen.dart';


class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) { // 'context' is available here
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. Search Bar
          // MODIFICATION 1: Pass 'context' to the helper method

          // ... (rest of the build method is unchanged)
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildFaqList(context), // Pass context here as well for theme awareness

          const Divider(height: 48),

          const Text(
            'Contact Us',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildContactOption(
            context: context, // Pass context
            icon: Icons.email_outlined,
            title: 'Email Support',
            subtitle: 'Get help via email at support@autosage.com',
            onTap: () async {
              // ...
            },
          ),
          _buildContactOption(
            context: context, // Pass context
            icon: Icons.phone_outlined,
            title: 'Call Us',
            subtitle: 'Speak to a support agent at +968 99887766',
            onTap: () {
            },
          ),

          const Divider(height: 48),

          const Text(
            'Feedback',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          _buildContactOption(
            context: context,
            icon: Icons.feedback_outlined,
            title: 'Feedback',
            subtitle:
            'Share your feedback on AutoSage! We’d love to hear your feedback to help us improve ☺️',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FeedbackScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }


  // Helper widget for the FAQ list - Now theme-aware
  Widget _buildFaqList(BuildContext context) {
    final faqs = {
      'What are the benefits of using AutoSage?':
      'AutoSage helps you quickly understand potential car problems, find nearby trusted garages, and keep a log of your vehicle\'s maintenance history, all in one app.',
      'How does the AI diagnosis work?':
      'Simply go to the chatbot screen and describe your car\'s issue (e.g., "I hear a rattling noise when I accelerate"). Our AI will analyze the symptoms and provide a potential diagnosis and its severity.',
      'How do I view my service history?':
      'Your service history is available on the "History" screen. It lists all past maintenance and repairs logged in the app.',
      'Can I reset my password?':
      'Yes, you can reset your password from the login screen by tapping the "Forgot Password?" link.',
    };

    return Column(
      children: faqs.entries
          .map((entry) => FaqItem(question: entry.key, answer: entry.value))
          .toList(),
    );
  }

  // Helper widget for contact options - Now theme-aware
  Widget _buildContactOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      // Card color will be determined by the theme
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, size: 30, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    );
  }
}

// A reusable widget for an expandable FAQ item - Now theme-aware
class FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  const FaqItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 0,
      // Adapt background color based on theme
      color: isDark ? Colors.grey[850] : Colors.grey[100],
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        // Adapt icon color
        iconColor: Theme.of(context).colorScheme.secondary,
        collapsedIconColor: Theme.of(context).textTheme.bodySmall?.color,
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        childrenPadding: const EdgeInsets.all(16.0),
        children: [
          Text(answer),
        ],
      ),
    );
  }
}

