import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Widgets/configuration_card.dart';
import '../Widgets/system_toggles_card.dart';


class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  bool chatbotEnabled = true;
  bool notificationsEnabled = true;
  bool maintenanceMode = false;

  int maxChatbotLength = 200;
  int maxHistoryEntries = 50;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final res = await http.get(
      Uri.parse("http://10.0.2.2:3000/api/admin/app-settings"),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      setState(() {
        chatbotEnabled = data['chatbot_enabled'];
        notificationsEnabled = data['notifications_enabled'];
        maintenanceMode = data['maintenance_mode'];
        maxChatbotLength = data['max_chatbot_length'];
        maxHistoryEntries = data['max_history_entries'];
      });
    }
  }

  Future<void> saveSettings() async {
    setState(() => isSaving = true);

    await http.put(
      Uri.parse("http://10.0.2.2:3000/api/admin/app-settings"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "chatbot_enabled": chatbotEnabled,
        "notifications_enabled": notificationsEnabled,
        "maintenance_mode": maintenanceMode,
        "max_chatbot_length": maxChatbotLength,
        "max_history_entries": maxHistoryEntries,
      }),
    );

    setState(() => isSaving = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Settings saved successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Settings")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SystemTogglesCard(
              chatbotEnabled: chatbotEnabled,
              notificationsEnabled: notificationsEnabled,
              maintenanceMode: maintenanceMode,
              onChatbotChanged: (v) => setState(() => chatbotEnabled = v),
              onNotificationsChanged: (v) =>
                  setState(() => notificationsEnabled = v),
              onMaintenanceChanged: (v) =>
                  setState(() => maintenanceMode = v),
            ),

            const SizedBox(height: 20),

            ConfigurationCard(
              maxChatbotLength: maxChatbotLength,
              maxHistoryEntries: maxHistoryEntries,
              onChatbotLengthChanged: (v) =>
                  setState(() => maxChatbotLength = v),
              onHistoryLimitChanged: (v) =>
                  setState(() => maxHistoryEntries = v),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: isSaving
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Icon(Icons.save_outlined),
                label: const Text("SAVE SETTINGS"),
                onPressed: isSaving ? null : saveSettings,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
