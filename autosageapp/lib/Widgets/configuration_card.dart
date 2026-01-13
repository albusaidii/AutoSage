import 'package:flutter/material.dart';

class ConfigurationCard extends StatelessWidget {
  final int maxChatbotLength;
  final int maxHistoryEntries;

  final ValueChanged<int> onChatbotLengthChanged;
  final ValueChanged<int> onHistoryLimitChanged;

  const ConfigurationCard({
    super.key,
    required this.maxChatbotLength,
    required this.maxHistoryEntries,
    required this.onChatbotLengthChanged,
    required this.onHistoryLimitChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _card(
      title: "Configuration",
      children: [
        _numberField(
          label: "Max chatbot response length",
          value: maxChatbotLength,
          onChanged: onChatbotLengthChanged,
        ),
        _numberField(
          label: "Max history entries per user",
          value: maxHistoryEntries,
          onChanged: onHistoryLimitChanged,
        ),
      ],
    );
  }

  Widget _numberField({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: value.toString(),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label),
        onChanged: (v) => onChanged(int.tryParse(v) ?? value),
      ),
    );
  }

  Widget _card({required String title, required List<Widget> children}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}
