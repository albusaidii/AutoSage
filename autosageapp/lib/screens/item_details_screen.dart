import 'package:flutter/material.dart';
import '../models/shop_models.dart';

class ItemDetailsScreen extends StatelessWidget {
  final Item item;

  const ItemDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: ListView(
        children: [
          // IMAGE
          AspectRatio(
            aspectRatio: 1.2,
            child: Hero(
              tag: 'item_${item.imageUrl}',
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.build, size: 50),
                ),
              ),
            ),
          ),


          // CONTENT
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NAME
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // PRICE
                Text(
                  "OMR ${item.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.cyan.shade300 : Colors.green.shade700,
                  ),
                ),

                const SizedBox(height: 16),

                // DESCRIPTION
                Text(
                  item.description.isNotEmpty
                      ? item.description
                      : "No description available for this item.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 30),

                // ACTION BUTTON (optional)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.phone),
                    label: const Text("Contact Shop"),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Contact feature coming soon")),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
