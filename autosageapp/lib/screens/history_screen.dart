import 'package:flutter/material.dart';
import '../utils/theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = [
      {'date': '2025-10-01', 'issue': 'Flat tire', 'result': 'Replaced tire'},
      {'date': '2025-09-18', 'issue': 'Engine overheating', 'result': 'Checked coolant'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Vehicle History',
        style: TextStyle(
          color: Colors.white,      // Sets the text color to white
          fontWeight: FontWeight.bold, // Makes the text bolder
        ),
      ), backgroundColor: primaryColor),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: entries.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final e = entries[i];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.history),
                title: Text(e['issue']!),
                subtitle: Text(e['date']!),
                trailing: Text(e['result']!, style: const TextStyle(color: Colors.grey)),
              ),
            );
          },
        ),
      ),
    );
  }
}
