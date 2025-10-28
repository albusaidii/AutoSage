import 'package:flutter/material.dart';
import '../main.dart'; // Or wherever MainPage is
import '../Widgets/custom_button.dart';
import '../Widgets/custom_textfield.dart';
import 'forget_password_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Your existing logo
              Image.asset(
                'C:/Users/USER/AutoSage/autosageapp/lib/images/logo.png', // Path to your logo
                width: 400,
                height: 400,
              ),
              const SizedBox(height: 20),

              // Your existing email field
              CustomTextField(controller: emailController, hintText: 'Email'),
              const SizedBox(height: 10),

              // Your existing password field
              CustomTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
                isPassword: true,
              ),
              const SizedBox(height: 10),

              // --- START: ADD FORGOT PASSWORD BUTTON HERE ---
              // ... inside the build method

              // --- START: ADD FORGOT PASSWORD BUTTON HERE ---
              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Navigate to the ForgotPasswordScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text('Forgot Password?'),
                ),
              ),
              // --- END: ADD FORGOT PASSWORD BUTTON HERE ---

              // ...

              // --- END: ADD FORGOT PASSWORD BUTTON HERE ---

              const SizedBox(height: 20),

              // Your existing Login button
              CustomButton(
                text: 'Login',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainPage()),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Your existing "Sign Up" button
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupScreen()),
                  );
                },
                child: const Text("Don't have an account? Sign up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
