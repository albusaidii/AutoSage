import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        // If this screen is pushed from another screen, a back button will appear automatically.
        // If not, you might want to handle navigation differently.
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. Search Bar (Optional but helpful)
          _buildSearchBar(),
          const SizedBox(height: 24),

          // 2. Frequently Asked Questions Section
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildFaqList(),

          const Divider(height: 48),

          // 3. Contact Us Section
          const Text(
            'Contact Us',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildContactOption(
            icon: Icons.email_outlined,
            title: 'Email Support',
            subtitle: 'Get help via email at support@autosage.com',
            onTap: () async {
              final Uri emailUri = Uri(
                scheme: 'mailto',
                path: 'support@autosage.com',
                query: 'subject=AutoSage Support Request&body=Hello AutoSage Team,',
              );

              if (await canLaunchUrl(emailUri)) {
                await launchUrl(emailUri);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not open email client.')),
                );
              }
            },
          ),

          _buildContactOption(
            icon: Icons.phone_outlined,
            title: 'Call Us',
            subtitle: 'Speak to a support agent at +1 (555) 123-4567',
            onTap: () {
              // TODO: Implement phone number launcher
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening phone dialer...')),
              );
            },
          ),
        ],
      ),
    );
  }

  // Helper widget for the search bar
  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search for help...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  // Helper widget for the FAQ list
  Widget _buildFaqList() {
    // You can fetch these questions from a database or a local source
    final faqs = {
      'How do I add a new car to my garage?':
      'To add a car, go to the "Garage" screen and tap the "+" icon. Fill in your vehicle\'s details and tap "Save".',
      'How does the chatbot work?':
      'Our chatbot uses advanced AI to diagnose potential car issues. Simply describe the problem, and it will provide guidance and suggestions.',
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

  // Helper widget for contact options
  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    );
  }
}

// A reusable widget for an expandable FAQ item
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
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
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
