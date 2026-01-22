import 'package:autosageapp/utils/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/chatbot_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/splash_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(
    // The ChangeNotifierProvider wraps the entire application.
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const AutoSageApp(),
    ),
  );
}

// This is the root widget of my application.
class AutoSageApp extends StatelessWidget {
  const AutoSageApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer listens for changes in ThemeNotifier and rebuilds the MaterialApp.
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'AutoSage',
          themeMode: themeNotifier.themeMode, // This is the line for theme switching.

          // Light Theme (default)
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: primaryColor, // from your theme.dart
            scaffoldBackgroundColor: Colors.grey[100],
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 1,
              titleTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 20),
              iconTheme: IconThemeData(color: Colors.black87),
            ),
          ),

          // Dark Theme
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: primaryColor,
            scaffoldBackgroundColor: const Color(0xFF121212),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1F1F1F),
              elevation: 0,
              titleTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
              iconTheme: IconThemeData(color: Colors.white),
            ),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}

// MainPage holds the Bottom Navigation Bar and manages the main screens.
class MainPage extends StatefulWidget {

  final String fullName;

  const MainPage({super.key, required this.fullName});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // The list of pages to be displayed by the BottomNavigationBar.
    final List<Widget> pages = [
      HomeScreen(
        // This callback allows HomeScreen to tell MainPage to switch tabs.
        onProfileTap: () => _onItemTapped(2),
        fullName: widget.fullName,
      ),
      const ChatbotScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      // The body displays the currently selected page from the list.
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: primaryColor,
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
