import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _messageController = TextEditingController();
  int _rating = 5;
  String _type = "chatbot";
  bool isSubmitting = false;

  Future<void> submitFeedback() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("userId");

    if (userId == null || _messageController.text.trim().isEmpty) return;

    setState(() => isSubmitting = true);

    await http.post(
      Uri.parse("http://10.0.2.2:3000/api/feedback"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "type": _type,
        "rating": _rating,
        "message": _messageController.text.trim(),
      }),
    );

    setState(() => isSubmitting = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Feedback sent. Thank you 🚀")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0E1117) : Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Feedback"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _glassCard(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Feedback Type", isDark),
                  const SizedBox(height: 12),
                  _futuristicDropdown(isDark),
                ],
              ),
            ),


            const SizedBox(height: 20),

            _glassCard(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Rate Your Experience", isDark),
                  const SizedBox(height: 12),
                  _ratingBar(),
                ],
              ),
            ),


            const SizedBox(height: 20),

            _glassCard(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Your Message", isDark),
                  const SizedBox(height: 12),
                  _messageField(isDark),
                ],
              ),
            ),

            const Spacer(),

            _submitButton(),
          ],
        ),
      ),
    );
  }

  // ======================
  // UI COMPONENTS
  // ======================

  Widget _glassCard({required Widget child, required bool isDark}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.15)
                  : Colors.black.withOpacity(0.08),
            ),
            gradient: LinearGradient(
              colors: isDark
                  ? [
                Colors.white.withOpacity(0.12),
                Colors.white.withOpacity(0.05),
              ]
                  : [
                Colors.white.withOpacity(0.85),
                Colors.white.withOpacity(0.65),
              ],
            ),
          ),
          child: child,
        ),
      ),
    );
  }


  Widget _sectionTitle(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        letterSpacing: 1.1,
        color: isDark ? Colors.white70 : Colors.black87,
        fontWeight: FontWeight.w600,
      ),
    );
  }


  Widget _futuristicDropdown(bool isDark) {
    return DropdownButtonFormField(
      dropdownColor: isDark ? const Color(0xFF1C1F26) : Colors.white,
      value: _type,
      items: const [
        DropdownMenuItem(value: "chatbot", child: Text("🤖 Chatbot")),
        DropdownMenuItem(value: "app", child: Text("📱 App Experience")),
        DropdownMenuItem(value: "bug", child: Text("⚠️ Report")),
        DropdownMenuItem(value: "suggestion", child: Text("💡 Suggestion")),
      ],
      onChanged: (v) => setState(() => _type = v!),
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark ? const Color(0xFF1C1F26) : Colors.grey.shade100,
        border: const OutlineInputBorder(borderSide: BorderSide.none),
      ),
    );
  }


  Widget _ratingBar() {
    return Row(
      children: List.generate(5, (i) {
        return IconButton(
          icon: Icon(
            i < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
            color: Colors.amberAccent,
            size: 32,
          ),
          onPressed: () => setState(() => _rating = i + 1),
        );
      }),
    );
  }

  Widget _messageField(bool isDark) {
    return TextField(
      controller: _messageController,
      maxLines: 4,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: "Describe your experience...",
        hintStyle: TextStyle(
          color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF1C1F26) : Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isSubmitting ? null : submitFeedback,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: isSubmitting
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
              "SEND FEEDBACK",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
