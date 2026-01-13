import 'package:flutter/material.dart';
import '../Widgets/item_card.dart';
import '../models/shop_models.dart';
import 'item_details_screen.dart';

class ShopItemsScreen extends StatefulWidget {
  final Shop shop;
  const ShopItemsScreen({super.key, required this.shop});

  @override
  State<ShopItemsScreen> createState() => _ShopItemsScreenState();
}

class _ShopItemsScreenState extends State<ShopItemsScreen> {
  late List<Item> allItems;
  late List<Item> filteredItems;

  @override
  void initState() {
    super.initState();
    allItems = widget.shop.items;
    filteredItems = allItems;
  }

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = allItems;
      } else {
        filteredItems = allItems.where((item) {
          final q = query.toLowerCase();
          return item.name.toLowerCase().contains(q) ||
              item.description.toLowerCase().contains(q);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(widget.shop.name)),
      body: CustomScrollView(
        slivers: [

          // =====================
          // SHOP HEADER
          // =====================
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    widget.shop.logoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.store, size: 60),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.shop.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 18),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              widget.shop.address,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
              ],
            ),
          ),

          // =====================
          // SEARCH BAR
          // =====================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                onChanged: _onSearch,
                decoration: InputDecoration(
                  hintText: "Search parts...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor:
                  isDark ? const Color(0xFF1F1F1F) : Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),

          // =====================
          // ITEMS TITLE
          // =====================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Text(
                "Available Parts",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // =====================
          // EMPTY STATE
          // =====================
          if (filteredItems.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    "No parts found",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),

          // =====================
          // ITEMS GRID
          // =====================
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final item = filteredItems[index];
                  return ItemCard(item: item);
                },
                childCount: filteredItems.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }
}
