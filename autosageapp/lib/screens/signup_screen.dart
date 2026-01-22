import 'package:autosageapp/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:autosageapp/utils/theme.dart';
import '../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  // === Controllers ===
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Changed: Use theme background color instead of hardcoded grey
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(isDark),
                  const SizedBox(height: 40),

                  _buildUsernameField(context),
                  const SizedBox(height: 16),

                  _buildEmailField(context),
                  const SizedBox(height: 16),

                  _buildPhoneNumberField(context),
                  const SizedBox(height: 16),

                  _buildPasswordField(context),
                  const SizedBox(height: 16),

                  _buildConfirmPasswordField(context),
                  const SizedBox(height: 30),

                  _buildSignUpButton(),
                  const SizedBox(height: 20),

                  _buildSignInLink(context, isDark),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================
  // HEADER
  // ===========================
  Widget _buildHeader(bool isDark) {
    return Column(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xEB419BFB), const Color(0xFF023E61).withOpacity(0.1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(Icons.person_add_alt_1_outlined, color: Colors.white, size: 50),
        ),
        const SizedBox(height: 20),

        Text(
          'Create Your Account',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            // Changed: Text color adapts to theme
            color: isDark ? Colors.white : const Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),

        Text(
          'Join the AutoSage community today!',
          style: TextStyle(
              fontSize: 16,
              // Changed: Subtitle color is lighter in dark mode
              color: isDark ? Colors.grey[400] : Colors.grey[600]
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ===========================
  // INPUT FIELDS
  // ===========================
  Widget _buildUsernameField(BuildContext context) {
    return TextFormField(
      controller: nameController,
      decoration: _buildInputDecoration(
        context: context,
        hintText: 'Full Name',
        prefixIcon: Icons.person_outline,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your name';
        }
        final nameRegex = RegExp(r'^[a-zA-Z]');
        if (!nameRegex.hasMatch(value)) {
          return 'Enter a valid name';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: _buildInputDecoration(
        context: context,
        hintText: 'Email Address',
        prefixIcon: Icons.alternate_email,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Email is required';
        final emailRegex = RegExp(r'^[a-zA-Z][a-zA-Z0-9._%+-]*@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
        if (!emailRegex.hasMatch(value)) return 'Enter a valid email address';
        return null;
      },
    );
  }

  Widget _buildPhoneNumberField(BuildContext context) {
    return TextFormField(
      controller: phoneController,
      keyboardType: TextInputType.phone,
      decoration: _buildInputDecoration(
        context: context,
        hintText: '+968 Phone Number',
        prefixIcon: Icons.phone_outlined,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Phone number is required';
        if (value.length != 8) return 'Phone number must be 8 digits';
        if (!value.startsWith('9') && !value.startsWith('7')) return 'Must start with 7 or 9';
        return null;
      },
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: _buildInputDecoration(
        context: context,
        hintText: 'Password',
        prefixIcon: Icons.lock_outline,
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
      ),
      validator: (value) => value == null || value.length < 6 ? 'Min 6 characters' : null,
    );
  }

  Widget _buildConfirmPasswordField(BuildContext context) {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: !_isConfirmPasswordVisible,
      decoration: _buildInputDecoration(
        context: context,
        hintText: 'Confirm Password',
        prefixIcon: Icons.lock_outline,
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please confirm your password';
        if (value != _passwordController.text) return 'Passwords do not match';
        return null;
      },
    );
  }

  // ===========================
  // SIGN UP BUTTON
  // ===========================
  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: _isLoading
          ? null
          : () async {
        if (!_formKey.currentState!.validate()) return;

        setState(() => _isLoading = true);

        final result = await AuthService.signup(
          nameController.text,
          emailController.text,
          phoneController.text,
          _passwordController.text,
        );

        if (!mounted) return;
        setState(() => _isLoading = false);

        if (result['message'] == 'User registered successfully') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
              settings: const RouteSettings(
                arguments: 'Account created successfully! Please sign in.',
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'An unknown error occurred.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: _isLoading
          ? const SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      )
          : const Text('SIGN UP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  // ===========================
  // SIGN-IN LINK
  // ===========================
  Widget _buildSignInLink(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            "Already have an account?",
            style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600])
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          child: Text(
            'Sign In',
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // ===========================
  // INPUT DECORATION
  // ===========================
  InputDecoration _buildInputDecoration({
    required BuildContext context,
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, color: isDark ? Colors.grey[400] : Colors.grey[600]),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Theme.of(context).cardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    );
  }
}