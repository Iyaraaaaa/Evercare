import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Sample notification list
  final List<Map<String, String>> _notifications = [
    {
      "title": "Appointment Reminder",
      "message": "You have an appointment with Dr. Smith at 10:30 AM.",
      "time": "10 min ago"
    },
    {
      "title": "Payment Confirmation",
      "message": "Your payment for consultation has been received.",
      "time": "1 hour ago"
    },
    {
      "title": "New Doctor Added",
      "message": "Dr. Jane Doe has been added to your favorites.",
      "time": "3 hours ago"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: Icon(Icons.notifications, color: Colors.blue),
              title: Text(
                notification["title"]!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(notification["message"]!),
              trailing: Text(
                notification["time"]!,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}
