import 'package:autosageapp/screens/sparepart_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/feature_card.dart';
import 'cars_screen.dart';
import 'chatbot_screen.dart';
import 'garage_screen.dart';
import 'history_screen.dart';
import '../utils/theme.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onProfileTap;
  const HomeScreen({super.key, this.onProfileTap});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hi, Hamed 👋',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('What would you like AutoSage to do today?',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: onProfileTap, //  Calls the callback from MainPage
                    customBorder: const CircleBorder(),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: primaryColor,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 26),

              // Car summary card (visual emphasis)
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      // placeholder image: add your asset or keep Icon
                      Container(
                        width: 90,
                        height: 70,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.directions_car, color: primaryColor, size: 44),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Jeep Wrangler 2021', style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text('3.6L V6, Automatic', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CarsScreen())),
                        icon: const Icon(Icons.arrow_forward_ios, color: accentColor),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Grid: features
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  children: [
                    FeatureCard(
                      icon: Icons.quiz,
                      label: 'Diagnose Issue',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatbotScreen())),
                    ),
                    FeatureCard(
                      icon: Icons.map_outlined,
                      label: 'Find Garage',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GarageScreen())),
                    ),
                    FeatureCard(
                      icon: Icons.history_toggle_off,
                      label: 'My History',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
                    ),
                    FeatureCard(
                      icon: Icons.build_circle_outlined,
                      label: 'Spare Parts',
                      // This is the updated part
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SparePartScreen())),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
