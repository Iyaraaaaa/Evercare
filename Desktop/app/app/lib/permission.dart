import 'package:flutter/material.dart';

class PermissionPage extends StatefulWidget {
  @override
  _PermissionPageState createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  bool backgroundAppRefresh = true;
  bool mobileData = true;
  bool locationAccess = false; // Initial state for Location Access toggle
  bool notificationAccess = true; // Initial state for Notification Access toggle

  void _navigateToSetting(String settingName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening $settingName settings...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Settings', style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          _buildSectionTitle('ALLOW APP ACCESS'),
          _buildSettingsTile(Icons.location_on, 'Location', 'While Using', locationAccess, (value) {
            setState(() {
              locationAccess = value;
            });
          }),
          _buildSettingsTile(Icons.notifications, 'Notifications', 'Banners, Sounds, Badges', notificationAccess, (value) {
            setState(() {
              notificationAccess = value;
            });
          }),
          _buildSettingsTile(Icons.message, 'Messages', '', null, (value) {}), // no toggle, just navigation
          _buildSettingsTile(Icons.folder, 'File Manager', '', null, (value) {}), // no toggle, just navigation
          _buildSettingsTile(Icons.storage, 'Storage', '', null, (value) {}), // no toggle, just navigation
          _buildToggleTile(Icons.refresh, 'Background App Refresh', backgroundAppRefresh, (value) {
            setState(() => backgroundAppRefresh = value);
          }),
          _buildToggleTile(Icons.network_cell, 'Mobile Data', mobileData, (value) {
            setState(() => mobileData = value);
          }),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    IconData icon,
    String title,
    String subtitle,
    bool? value, // Use nullable boolean to decide if this tile needs a switch
    Function(bool)? onChanged, // Null if no switch
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue, size: 28),
      title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      subtitle: subtitle.isNotEmpty ? Text(subtitle, style: TextStyle(color: Colors.grey)) : null,
      trailing: value != null // Only show switch if value is not null
          ? Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.green,
            )
          : Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      onTap: () {
        if (onChanged == null) {
          _navigateToSetting(title); // Navigate if no toggle
        }
      },
      tileColor: Colors.white,
    );
  }

  Widget _buildToggleTile(IconData icon, String title, bool value, Function(bool) onChanged) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey, size: 28),
      title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.green,
      ),
      tileColor: Colors.white,
    );
  }
}
