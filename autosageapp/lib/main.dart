import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/chatbot_screen.dart';
import 'screens/profile_screen.dart';
import 'utils/theme.dart';
import 'package:autosageapp/screens/splash_screen.dart';
// Other imports...


void main() {
  runApp(const AutoSageApp());
}

class AutoSageApp extends StatelessWidget {
  const AutoSageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AutoSage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(
        onProfileTap: () {
          setState(() => _selected = 2); // Switch to Profile tab
        },
      ),
      const ChatbotScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[_selected],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selected,
        onTap: (i) => setState(() => _selected = i),
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

