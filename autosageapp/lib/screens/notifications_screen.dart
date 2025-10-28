import 'package:flutter/material.dart';

// Data model for a single notification
class AppNotification {
  final String title;
  final String message;
  final DateTime time;
  final IconData icon;
  final Color iconColor;
  bool isRead;

  AppNotification({
    required this.title,
    required this.message,
    required this.time,
    this.icon = Icons.notifications,
    this.iconColor = Colors.blue,
    this.isRead = false,
  });
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Sample list of notifications. In a real app, you would fetch this from a server.
  final List<AppNotification> _notifications = [
    AppNotification(
      title: 'Service Reminder',
      message: 'Your upcoming oil change is scheduled for this Friday.',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      icon: Icons.calendar_today,
      iconColor: Colors.blue,
    ),
    AppNotification(
      title: 'New Diagnostic Report',
      message: 'The chatbot has generated a new report for your vehicle.',
      time: DateTime.now().subtract(const Duration(days: 1)),
      icon: Icons.description,
      iconColor: Colors.green,
      isRead: true,
    ),
    AppNotification(
      title: 'Tire Pressure Alert',
      message: 'Low tire pressure detected in the front-left tire.',
      time: DateTime.now().subtract(const Duration(days: 3)),
      icon: Icons.warning,
      iconColor: Colors.orange,
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          // Optional: Add a "Mark all as read" button
          if (_notifications.any((n) => !n.isRead))
            IconButton(
              icon: const Icon(Icons.done_all),
              onPressed: () {
                setState(() {
                  for (var notification in _notifications) {
                    notification.isRead = true;
                  }
                });
              },
              tooltip: 'Mark all as read',
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : _buildNotificationList(),
    );
  }

  // Widget to display when there are no notifications
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'You are all caught up!',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  // Widget to display the list of notifications
  Widget _buildNotificationList() {
    return ListView.builder(
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: notification.iconColor.withOpacity(0.1),
              child: Icon(
                notification.icon,
                color: notification.iconColor,
              ),
            ),
            title: Text(
              notification.title,
              style: TextStyle(
                fontWeight:
                notification.isRead ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            subtitle: Text(notification.message),
            trailing: !notification.isRead
                ? const Icon(
              Icons.circle,
              color: Colors.blue,
              size: 12,
            )
                : null,
            onTap: () {
              // Mark as read when tapped
              setState(() {
                notification.isRead = true;
              });
              // TODO: Navigate to a detailed view if necessary
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tapped on "${notification.title}"')),
              );
            },
          ),
        );
      },
    );
  }
}
