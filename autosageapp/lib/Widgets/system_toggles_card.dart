import 'package:flutter/material.dart';

class SystemTogglesCard extends StatelessWidget {
  final bool chatbotEnabled;
  final bool notificationsEnabled;
  final bool maintenanceMode;

  final ValueChanged<bool> onChatbotChanged;
  final ValueChanged<bool> onNotificationsChanged;
  final ValueChanged<bool> onMaintenanceChanged;

  const SystemTogglesCard({
    super.key,
    required this.chatbotEnabled,
    required this.notificationsEnabled,
    required this.maintenanceMode,
    required this.onChatbotChanged,
    required this.onNotificationsChanged,
    required this.onMaintenanceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _card(
      title: "System Toggles",
      children: [
        _toggle("Enable Chatbot", chatbotEnabled, onChatbotChanged),
        _toggle(
            "Enable Notifications", notificationsEnabled, onNotificationsChanged),
        _toggle(
            "Maintenance Mode", maintenanceMode, onMaintenanceChanged),
      ],
    );
  }

  Widget _toggle(
      String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
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
