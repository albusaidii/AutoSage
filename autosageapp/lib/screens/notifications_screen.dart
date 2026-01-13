import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AppNotification {
  final int userNotificationId;
  final String title;
  final String message;
  final DateTime time;
  final IconData icon;
  final Color iconColor;
  bool isRead;

  AppNotification({
    required this.userNotificationId,
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.isRead,
  });
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final String baseUrl = "http://10.0.2.2:3000/api";

  List<AppNotification> _notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  // ===============================
  // FETCH NOTIFICATIONS
  // ===============================
  Future<void> fetchNotifications() async {
    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt("userId");

      if (userId == null) {
        setState(() => isLoading = false);
        return;
      }

      final res =
      await http.get(Uri.parse("$baseUrl/notifications/$userId"));

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);

        _notifications = data.map<AppNotification>((n) {
          return AppNotification(
            userNotificationId: n["id"],
            title: n["title"],
            message: n["message"],
            time: DateTime.parse(n["created_at"]),
            icon: _iconFromString(n["icon"]),
            iconColor: _colorFromString(n["icon_color"]),
            isRead: n["is_read"] == 1,
          );
        }).toList();
      }
    } catch (e) {
      debugPrint("Notification fetch error: $e");
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  // ===============================
  // MARK ONE AS READ
  // ===============================
  Future<void> markAsRead(AppNotification notification) async {
    if (notification.isRead) return;

    await http.put(
      Uri.parse(
          "$baseUrl/notifications/${notification.userNotificationId}/read"),
    );

    setState(() {
      notification.isRead = true;
    });
  }

  // ===============================
  // MARK ALL AS READ (FIXED)
  // ===============================
  Future<void> markAllAsRead() async {
    for (final n in _notifications.where((n) => !n.isRead)) {
      await http.put(
        Uri.parse("$baseUrl/notifications/${n.userNotificationId}/read"),
      );
      n.isRead = true;
    }

    setState(() {});
  }

  // ===============================
  // UI
  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          if (_notifications.any((n) => !n.isRead))
            IconButton(
              icon: const Icon(Icons.done_all),
              tooltip: "Mark all as read",
              onPressed: markAllAsRead,
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
          ? _buildEmptyState()
          : _buildNotificationList(),
    );
  }

  // ===============================
  // EMPTY STATE
  // ===============================
  Widget _buildEmptyState() {
    final color =
    Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.6);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined,
              size: 80, color: Theme.of(context).disabledColor),
          const SizedBox(height: 20),
          Text("No Notifications",
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 10),
          Text("You are all caught up!",
              style: TextStyle(fontSize: 16, color: color)),
        ],
      ),
    );
  }

  // ===============================
  // LIST
  // ===============================
  Widget _buildNotificationList() {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final n = _notifications[index];
        final isUnread = !n.isRead;

        return Card(
          color: isUnread && !isDark
              ? Colors.blue.shade50
              : isUnread && isDark
              ? Colors.grey[800]
              : null,
          margin:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: n.iconColor.withOpacity(0.15),
              child: Icon(n.icon, color: n.iconColor),
            ),
            title: Text(
              n.title,
              style: TextStyle(
                  fontWeight:
                  isUnread ? FontWeight.bold : FontWeight.normal),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(n.message),
            ),
            trailing: isUnread
                ? Icon(Icons.circle,
                size: 12,
                color: Theme.of(context).primaryColor)
                : null,
            onTap: () => markAsRead(n),
          ),
        );
      },
    );
  }

  // ===============================
  // HELPERS
  // ===============================
  IconData _iconFromString(String? icon) {
    switch (icon) {
      case "warning":
        return Icons.warning;
      case "offer":
        return Icons.local_offer;
      case "calendar":
        return Icons.calendar_today;
      case "celebration":
        return Icons.celebration;
      default:
        return Icons.notifications;
    }
  }

  Color _colorFromString(String? color) {
    switch (color) {
      case "green":
        return Colors.green;
      case "orange":
        return Colors.orange;
      case "purple":
        return Colors.purple;
      case "red":
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
