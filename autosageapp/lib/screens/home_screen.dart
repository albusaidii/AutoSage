import 'package:autosageapp/screens/sparepart_screen.dart';
import 'package:flutter/material.dart';
import 'chatbot_screen.dart';
import 'garage_screen.dart';
import 'history_screen.dart';


// Data model for the tips section
class Tip {
  final String title;
  final IconData icon;
  final Color color;

  const Tip({required this.title, required this.icon, required this.color});
}

class HomeScreen extends StatelessWidget {
  final VoidCallback? onProfileTap;
  final String fullName;
  const HomeScreen({
    super.key,
    this.onProfileTap,
    required this.fullName,
  });


  // Sample data for the tips list
  final List<Tip> _tips = const [
    Tip(
        title: 'Check your tire pressure monthly for better fuel economy.',
        icon: Icons.air,
        color: Colors.lightBlue),
    Tip(
        title: 'Rotate your tires every 10,000 km to ensure even wear.',
        icon: Icons.sync,
        color: Colors.orange),
    Tip(
        title: 'Keep an emergency kit in your car for unexpected situations.',
        icon: Icons.medical_services_outlined,
        color: Colors.redAccent),
  ];

  @override
  Widget build(BuildContext context) {
    // Dark mode theme support
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  Top Header
                _buildHeader(context, isDark),
                const SizedBox(height: 30),

                //  Main Action: Diagnose Issue
                _buildPrimaryActionCard(context, isDark),
                const SizedBox(height: 30),

                //  Secondary Actions
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSecondaryActionRow(context, isDark),
                const SizedBox(height: 30),

                //  Recent Activity / History Section
                Text(
                  'Recent Activity',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _buildHistoryCard(context, isDark),

                //  "Tips & Insights" section
                const SizedBox(height: 30),
                Text(
                  'Tips & Insights',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTipsList(isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //  Builder Methods

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hi, $fullName 👋',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 6),
            Text('Welcome to your command center.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                )),
          ],
        ),
        InkWell(
          onTap: onProfileTap,
          customBorder: const CircleBorder(),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            child: Icon(Icons.person,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 26),
          ),
        )
      ],
    );
  }

  Widget _buildPrimaryActionCard(BuildContext context, bool isDark) {
    return _ThemedCard(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => const ChatbotScreen())),
      isDark: isDark,
      gradient: const LinearGradient(
        colors: [Color(0xFF00AEEF), Color(0xFF0072B5)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: const Row(
        children: [
          Icon(Icons.psychology_outlined, color: Colors.white, size: 40),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Diagnosis',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(height: 4),
                Text('Tap to analyze vehicle issues.',
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
        ],
      ),
    );
  }

  Widget _buildSecondaryActionRow(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _ThemedCard(
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const GarageScreen())),
            isDark: isDark,
            gradient: const LinearGradient(
              colors: [Color(0xFF6F00F4), Color(0xFFA055FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.store_mall_directory_outlined,
                    color: Colors.white, size: 32),
                SizedBox(height: 8),
                Text('Garages',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _ThemedCard(
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const SparePartScreen())),
            isDark: isDark,
            gradient: const LinearGradient(
              colors: [Color(0xFFE84D7A), Color(0xFFFF8A8A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.build_circle_outlined, color: Colors.white, size: 32),
                SizedBox(height: 8),
                Text('Spare Parts',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(BuildContext context, bool isDark) {
    return _ThemedCard(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
      isDark: isDark,
      gradient: LinearGradient(
        colors: [
          Colors.green.shade700,
          Colors.green.shade500,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: const Row(
        children: [
          Icon(Icons.history_edu_outlined, color: Colors.white, size: 40),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Vehicle History',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(height: 4),
                Text('View all service records.',
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
        ],
      ),
    );
  }

  Widget _buildTipsList(bool isDark) {
    return ListView.builder(
      itemCount: _tips.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final tip = _tips[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            // 5. UPDATED: Tip card color and border adapt to the theme.
            color: isDark ? const Color(0xFF1F1F1F) : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: tip.color.withOpacity(0.15),
                child: Icon(tip.icon, color: tip.color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                // 6. UPDATED: Tip text color adapts to the theme.
                child: Text(
                  tip.title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ThemedCard extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final Gradient gradient;
  final bool isDark;

  const _ThemedCard({
    required this.child,
    required this.onTap,
    required this.gradient,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: gradient,
          boxShadow: isDark
              ? null
              : [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
