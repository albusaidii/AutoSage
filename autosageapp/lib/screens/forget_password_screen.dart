import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/theme.dart';
import 'reset_password_screen.dart';
import 'login_screen.dart'; // Import the login screen

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final res = await http.post(
        Uri.parse("http://10.0.2.2:3000/api/forgot-password"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": emailController.text.trim()}),
      );

      final data = jsonDecode(res.body);

      setState(() => isLoading = false);
      if (!mounted) return;

      if (res.statusCode == 200) {
        final token = data["token"]; // demo-only, may be null if email not found

        if (token == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Email does not exists.")),
          );
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ResetPasswordScreen(token: token)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Request failed")),
        );
      }
    } catch (_) {
      setState(() => isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Server error. Try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The AppBar provides the default back button if pushed correctly
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text("Enter your email to generate a reset token."),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Email is required";
                  if (!v.contains("@")) return "Enter a valid email";
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                child: isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
                    : const Text("Generate Reset Token"),
              ),
              const SizedBox(height: 12), // Add some space

              // --- NEW WIDGET: Back to Login Button ---
              TextButton(
                onPressed: () {
                  // Navigate back to the Login Screen.
                  // Using pushReplacement prevents stacking multiple login screens.
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text('Back to Login'),
              ),
              // --- END OF NEW WIDGET ---
            ],
          ),
        ),
      ),
    );
  }
}
