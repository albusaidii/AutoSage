import 'package:flutter/material.dart';
import '../utils/theme.dart'; // Make sure this path is correct

class GarageListItem extends StatefulWidget {
  final String name;
  final String distance;
  final VoidCallback onTap;

  const GarageListItem({
    super.key,
    required this.name,
    required this.distance,
    required this.onTap,
  });

  @override
  State<GarageListItem> createState() => _GarageListItemState();
}

class _GarageListItemState extends State<GarageListItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Use AnimatedContainer to smoothly animate the size change
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      // Apply the scaling transformation
      transform: Matrix4.identity()..scale(_isHovered ? 1.03 : 1.0),
      transformAlignment: Alignment.center,
      // Use MouseRegion to detect hover events
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Card(
          elevation: _isHovered ? 6 : 2, // Increase shadow on hover
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: primaryColor.withOpacity(0.12),
              child: const Icon(Icons.build, color: primaryColor),
            ),
            title: Text(widget.name),
            subtitle: Text(widget.distance),
            onTap: widget.onTap,
          ),
        ),
      ),
    );
  }
}
