import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Widgets/garage_list_item.dart';
import 'garage_detail_screen.dart';

class GarageScreen extends StatefulWidget {
  const GarageScreen({super.key});

  @override
  State<GarageScreen> createState() => _GarageScreenState();
}

class _GarageScreenState extends State<GarageScreen> {
  List garages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGarages();
  }

  Future<void> fetchGarages() async {
    try {
      final res = await http.get(
        Uri.parse("http://10.0.2.2:3000/api/garages"),
      );

      if (res.statusCode == 200) {
        setState(() {
          garages = jsonDecode(res.body);
          isLoading = false;
        });
      } else {
        isLoading = false;
      }
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nearby Garages")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Map placeholder
            SizedBox(
              height: 180,
              child: Image.asset('lib/images/map.png'),
            ),
            const SizedBox(height: 14),

            // Content
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : garages.isEmpty
                  ? const Center(child: Text("No garages available"))
                  : ListView.separated(
                itemCount: garages.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 6),
                itemBuilder: (context, i) {
                  final g = garages[i];

                  // IMPORTANT: backend returns 0 / 1
                  final bool isActive = g['is_active'] == 1;

                  return GarageListItem(
                    name: g['name'],
                    isActive: isActive,
                    onTap: isActive
                        ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              GarageDetailScreen(
                                garageName: g['name'],
                                address: g['address'],
                                directionsUrl:
                                g['maps_url'] ?? g['address'],
                                phoneNumber:
                                g['phone'] ?? '',
                              ),
                        ),
                      );
                    }
                        : null, // 🚫 disabled garages blocked
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
