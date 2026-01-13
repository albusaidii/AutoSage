import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/theme.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String token;
  const ResetPasswordScreen({super.key, required this.token});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final passController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    passController.dispose();
    super.dispose();
  }

  Future<void> _reset() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final res = await http.post(
        Uri.parse("http://10.0.2.2:3000/api/reset-password"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "token": widget.token,
          "newPassword": passController.text.trim(),
        }),
      );

      final data = jsonDecode(res.body);
      setState(() => isLoading = false);
      if (!mounted) return;

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password reset successful. Please login.")),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
        );
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Reset failed")),
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
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text("Reset token: ${widget.token}"),
              const SizedBox(height: 16),
              TextFormField(
                controller: passController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "New Password"),
                validator: (v) {
                  if (v == null || v.length < 6) return "Min 6 characters";
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _reset,
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                child: isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
                    : const Text("Reset Password"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
