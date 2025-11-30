import 'package:flutter/material.dart';
import '../Widgets/garage_list_item.dart';
import '../utils/theme.dart';

class GarageScreen extends StatelessWidget {
  const GarageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // list of garages (static)
    final garages = [
      {'name': 'Al-Hilal Auto Repair', 'distance': '2.1 km'},
      {'name': 'Speedy Garage', 'distance': '3.3 km'},
      {'name': 'City Auto Care', 'distance': '4.0 km'},
      {'name': 'Pro Tech Auto', 'distance': '5.5 km'}, // Added more for demonstration
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Garages',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Placeholder for map area
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(child: Icon(Icons.map_outlined, size: 64, color: Colors.grey)),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.separated(
                itemCount: garages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 4), // Reduced separator height
                itemBuilder: (context, i) {
                  final g = garages[i];
                  // 2. Use the new GarageListItem widget
                  return GarageListItem(
                    name: g['name']!,
                    distance: g['distance']!,
                    onTap: () {
                      // TODO: Implement navigation or action for this garage
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tapped on ${g['name']}')),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
