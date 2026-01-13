import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../utils/theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  bool isLoading = false;
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      userId = prefs.getInt("userId");
      nameController.text = prefs.getString("fullName") ?? "";
      emailController.text = prefs.getString("email") ?? "";
      phoneController.text = prefs.getString("phone") ?? "";
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final result = await AuthService.updateProfile(
      userId: userId!,
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
    );

    setState(() => isLoading = false);

    if (!mounted) return;

    if (result["message"] == "Profile updated successfully") {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString("fullName", nameController.text.trim());
      await prefs.setString("email", emailController.text.trim());
      await prefs.setString("phone", phoneController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully, logout for changes to be applied")),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["message"] ?? "Update failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildField("Full Name", nameController),
              _buildField("Email", emailController,
                  keyboard: TextInputType.emailAddress),
              _buildField("Phone Number", phoneController,
                  keyboard: TextInputType.phone),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("SAVE CHANGES"),


              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
      String label,
      TextEditingController controller, {
        TextInputType keyboard = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) =>
        value == null || value.isEmpty ? "Required field" : null,
      ),
    );
  }
}
