import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminGarageManagementScreen extends StatefulWidget {
  const AdminGarageManagementScreen({super.key});

  @override
  State<AdminGarageManagementScreen> createState() =>
      _AdminGarageManagementScreenState();
}

class _AdminGarageManagementScreenState
    extends State<AdminGarageManagementScreen> {
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
        Uri.parse("http://10.0.2.2:3000/api/admin/garages"),
      );

      if (res.statusCode == 200) {
        setState(() {
          garages = jsonDecode(res.body);
          isLoading = false;
        });
      }
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  Future<void> toggleGarage(int garageId) async {
    await http.put(
      Uri.parse(
          "http://10.0.2.2:3000/api/admin/garages/$garageId/toggle"),
    );
    fetchGarages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Garage Management"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : garages.isEmpty
          ? const Center(child: Text("No garages added yet"))
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: garages.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final g = garages[i];
          final isActive = g["is_active"] == 1;

          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          g["name"],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Switch(
                        value: isActive,
                        onChanged: (_) =>
                            toggleGarage(g["garage_id"]),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    g["address"],
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),

                  if (g["phone"] != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      "📞 ${g["phone"]}",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      isActive ? "ACTIVE" : "DISABLED",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isActive
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
