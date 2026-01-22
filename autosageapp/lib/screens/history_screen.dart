import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<dynamic> historyEntries = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt("userId");

      if (userId == null) {
        throw Exception("User not logged in");
      }

      final response = await http.get(
        Uri.parse("http://10.0.2.2:3000/api/history/$userId"),
      );

      if (response.statusCode == 200) {
        setState(() {
          historyEntries = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load history");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteHistoryItem(int historyId, int index) async {
    try {
      final response = await http.delete(
        Uri.parse("http://10.0.2.2:3000/api/history/item/$historyId"),
      );

      if (response.statusCode == 200) {
        setState(() {
          historyEntries.removeAt(index);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("History entry deleted")),
        );
      } else {
        throw Exception("Delete failed");
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete history entry")),
      );
    }
  }



  // -----------------------
  // Severity helpers
  // -----------------------
  Color _severityColor(String severity) {
    switch (severity) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
      default:
        return Colors.green;
    }
  }

  IconData _severityIcon(String severity) {
    switch (severity) {
      case 'High':
        return Icons.error;
      case 'Medium':
        return Icons.warning;
      case 'Low':
      default:
        return Icons.check_circle;
    }
  }

  String _formatDate(String rawDate) {
    return rawDate.substring(0, 10); // YYYY-MM-DD
  }

  void confirmDelete(int historyId, int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Entry"),
        content: const Text(
          "Are you sure you want to delete this diagnosis?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteHistoryItem(historyId, index);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Diagnosis History',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade600,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : historyEntries.isEmpty
            ? const Center(child: Text("No diagnosis history found"))
            : ListView.separated(
          itemCount: historyEntries.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final e = historyEntries[i];
            final severityColor = _severityColor(e['severity']);

            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        _severityIcon(e['severity']),
                        color: severityColor,
                        size: 32,
                      ),
                      title: Text(
                        e['description'],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          "Status: ${e['status']}\nDate: ${_formatDate(e['created_at'])}",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                      ),
                      trailing: Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: severityColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          e['severity'],
                          style: TextStyle(
                            color: severityColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 4,
                    right: 4,
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: Colors.red,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => confirmDelete(e['history_id'], i),
                    ),
                  ),
                ],
              ),
            );

          },
        ),
      ),
    );
  }
}