import 'package:autosageapp/screens/forget_password_screen.dart';
import 'package:autosageapp/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:autosageapp/utils/theme.dart';
import '../main.dart';
import '../services/auth_service.dart';
import 'admin_login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to show the SnackBar after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check if any arguments were passed from the previous route
      final message = ModalRoute.of(context)?.settings.arguments as String?;
      if (message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green, // Use green for success messages
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 40),

                  _buildEmailField(),
                  const SizedBox(height: 16),

                  _buildPasswordField(),
                  const SizedBox(height: 12),

                  _buildForgotPasswordLink(),
                  const SizedBox(height: 24),

                  _buildSignInButton(),
                  const SizedBox(height: 20),

                  _buildSignUpLink(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return Column(
      children: [
        GestureDetector(
          onLongPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
            );
          },
          child: Container(
            height: 180,
            width: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xEB419BFB), const Color(0xFF023E61).withOpacity(0.1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Image.asset('lib/images/logo.png'),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Welcome To AutoSage!',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to continue to your account',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }

  // ================= EMAIL =================
  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: _buildInputDecoration(
        hintText: 'Email Address',
        prefixIcon: Icons.alternate_email,
      ),
      validator: (value) =>
      value == null || !value.contains('@') ? 'Enter a valid email' : null,
    );
  }

  // ================= PASSWORD =================
  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: !_isPasswordVisible,
      decoration: _buildInputDecoration(
        hintText: 'Password',
        prefixIcon: Icons.lock_outline,
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () =>
              setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
      ),
      validator: (value) =>
      value == null || value.isEmpty ? 'Enter your password' : null,
    );
  }

  // ================= FORGOT PASSWORD =================
  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
          );
        },
        child: Text('Forgot Password?', style: TextStyle(color: primaryColor)),
      ),
    );
  }

  // ================= SIGN IN =================
  Widget _buildSignInButton() {
    return ElevatedButton(
      onPressed: _isLoading
          ? null
          : () async {
        if (!_formKey.currentState!.validate()) return;

        setState(() => _isLoading = true);

        try {
          final result = await AuthService.login(
            emailController.text.trim(),
            passwordController.text.trim(),

          );

          if (!mounted) return;


          setState(() => _isLoading = false);

          final bool success = result["status"] == true;
          final token = result["token"];
          final user = result["user"];

          if (success && token != null && user != null) {
            final prefs = await SharedPreferences.getInstance();

            await prefs.setString("token", token);
            await prefs.setInt("userId", user["id"]);
            await prefs.setString("fullName", user["name"]);
            await prefs.setString("email", user["email"]);
            await prefs.setString("phone", user["phone"] ?? "");

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Login successful")),
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => MainPage(
                  fullName: user["name"],
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  result["message"] ?? "Invalid login credentials",
                ),
              ),
            );
          }
        } catch (e) {
          if (!mounted) return;

          setState(() => _isLoading = false);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Server error. Please try again."),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: _isLoading
          ? const SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      )
          : const Text(
        'SIGN IN',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }




  // ================= SIGN UP =================
  Widget _buildSignUpLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account?",
            style: TextStyle(color: Colors.grey[600])),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SignUpScreen()),
            );
          },
          child: Text('Sign Up',
              style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  // ================= INPUT DECORATION =================
  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(prefixIcon),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
