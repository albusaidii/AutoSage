import 'package:flutter/material.dart';
import '../utils/theme.dart';

class GarageScreen extends StatelessWidget {
  const GarageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // sample list of garages (static)
    final garages = [
      {'name': 'Al-Hilal Auto Repair', 'distance': '2.1 km', 'price': 'PKR 800'},
      {'name': 'Speedy Garage', 'distance': '3.3 km', 'price': 'PKR 1,000'},
      {'name': 'City Auto Care', 'distance': '4.0 km', 'price': 'PKR 1,200'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Garages',
        style: TextStyle(
        color: Colors.white,      // Sets the text color to white
        fontWeight: FontWeight.bold, // Makes the text bolder
      ),), backgroundColor: primaryColor),
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
              child: const Center(child: Icon(Icons.map, size: 64, color: Colors.grey)),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.separated(
                itemCount: garages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final g = garages[i];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(backgroundColor: primaryColor.withOpacity(0.12), child: const Icon(Icons.build, color: primaryColor)),
                      title: Text(g['name']!),
                      subtitle: Text(g['distance']!),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(g['price']!, style: const TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(backgroundColor: primaryColor, minimumSize: const Size(80, 30)),
                            child: const Text('Book', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
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
