import 'package:flutter/material.dart';

import '../utils/theme.dart';

// Data model for a single spare part
class SparePart {
  final String name;
  final String category;
  final double price;
  final String imageUrl; // URL for the part's image

  const SparePart({
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
  });
}

class SparePartScreen extends StatefulWidget {
  const SparePartScreen({super.key});

  @override
  State<SparePartScreen> createState() => _SparePartScreenState();
}

class _SparePartScreenState extends State<SparePartScreen> {
  // Sample data. In a real app, you would fetch this from a server.
  final List<SparePart> _allParts = [
    const SparePart(name: 'Oil Filter', category: 'Engine', price: 15.99, imageUrl: 'https://via.placeholder.com/150/FFC107/000000?Text=Oil+Filter'),
    const SparePart(name: 'Air Filter', category: 'Engine', price: 25.50, imageUrl: 'https://via.placeholder.com/150/8BC34A/000000?Text=Air+Filter'),
    const SparePart(name: 'Brake Pads', category: 'Brakes', price: 55.00, imageUrl: 'https://via.placeholder.com/150/F44336/000000?Text=Brake+Pads'),
    const SparePart(name: 'Spark Plug', category: 'Engine', price: 8.75, imageUrl: 'https://via.placeholder.com/150/9E9E9E/000000?Text=Spark+Plug'),
    const SparePart(name: 'Battery', category: 'Electrical', price: 120.00, imageUrl: 'https://via.placeholder.com/150/00BCD4/000000?Text=Battery'),
    const SparePart(name: 'Headlight Bulb', category: 'Electrical', price: 12.25, imageUrl: 'https://via.placeholder.com/150/FFEB3B/000000?Text=Headlight'),
  ];

  late List<SparePart> _filteredParts;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredParts = _allParts;
  }

  void _filterParts(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredParts = _allParts;
      } else {
        _filteredParts = _allParts
            .where((part) =>
        part.name.toLowerCase().contains(query.toLowerCase()) ||
            part.category.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spare Parts',
          style: TextStyle(
            color: Colors.white,      // Sets the text color to white
            fontWeight: FontWeight.bold, // Makes the text bolder
          ),),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          // --- SEARCH BAR ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _filterParts,
              decoration: InputDecoration(
                hintText: 'Search for parts (e.g., "Brake Pads")',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          // --- GRID OF SPARE PARTS ---
          Expanded(
            child: _filteredParts.isEmpty
                ? _buildEmptyState()
                : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 items per row
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8, // Adjust for item height
              ),
              itemCount: _filteredParts.length,
              itemBuilder: (context, index) {
                final part = _filteredParts[index];
                return SparePartCard(part: part);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text(
            'No parts found',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Try a different search term.',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

// A reusable widget for displaying a single spare part in a card
class SparePartCard extends StatelessWidget {
  final SparePart part;

  const SparePartCard({super.key, required this.part});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias, // Ensures the image respects the border radius
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(
              part.imageUrl,
              fit: BoxFit.cover,
              // Show a loading indicator while the image loads
              loadingBuilder: (context, child, progress) {
                return progress == null ? child : const Center(child: CircularProgressIndicator());
              },
              // Show an error icon if the image fails to load
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Icon(Icons.broken_image, size: 40, color: Colors.grey));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  part.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${part.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
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
