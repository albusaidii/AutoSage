import 'package:flutter/material.dart';
import '../utils/theme.dart';


class GarageListItem extends StatefulWidget {
  final String name;
  final bool isActive;
  final VoidCallback? onTap;

  const GarageListItem({
    super.key,
    required this.name,
    required this.isActive,
    this.onTap,
  });

  @override
  State<GarageListItem> createState() => _GarageListItemState();
}

class _GarageListItemState extends State<GarageListItem> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.isActive ? 1.0 : 0.45, // 👈 shaded when disabled
      child: Card(
        elevation: widget.isActive ? 3 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor:
            widget.isActive ? Colors.green.withOpacity(0.15) : Colors.grey.shade300,
            child: Icon(
              Icons.build,
              color: widget.isActive ? Colors.green : Colors.grey,
            ),
          ),
          title: Text(
            widget.name,
            style: TextStyle(
              color: widget.isActive ? null : Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: widget.isActive
              ? null
              : const Text(
            "DISABLED",
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: widget.onTap, // 🚫 null blocks navigation
        ),
      ),
    );
  }
}

