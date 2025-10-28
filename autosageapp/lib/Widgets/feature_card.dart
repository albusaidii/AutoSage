import 'package:flutter/material.dart';
import '../utils/theme.dart';

class FeatureCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  // State variable to track the hover state
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Use an AnimatedContainer for a smooth transition
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200), // Controls the speed of the animation
      curve: Curves.easeInOut, // Makes the animation feel smooth
      // Use Transform.scale to make the widget bigger
      transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
      transformAlignment: Alignment.center,
      child: MouseRegion(
        // Detect when the mouse enters or exits the card's area
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Card(
          elevation: _isHovered ? 6 : 3, // Increase shadow on hover
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(18), // Match the card's border radius
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, size: 48, color: primaryColor),
                const SizedBox(height: 12),
                Text(
                  widget.label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
