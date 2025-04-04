import 'package:flutter/material.dart';

class PrivacyPage extends StatefulWidget {
  @override
  _PrivacyPolicyPageState createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPage> {
  final List<bool> _isExpanded = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Privacy Policy',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Back Button
          onPressed: () {
            Navigator.pop(context); // Return to previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildExpansionTile(0, '1. Introduction', 'This is the introduction of the privacy policy.'),
            _buildExpansionTile(1, '2. Personal Data We Collect', 'Details about the data we collect.'),
            _buildExpansionTile(
                2,
                '3. Cookie Policy',
                'What are cookies?\n\nA cookie is a small file stored on your device. '
                    'We do not use cookies.'),
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionTile(int index, String title, String content) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(
          _isExpanded[index] ? Icons.remove : Icons.add,
          color: Colors.black,
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              content,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
        ],
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded[index] = expanded;
          });
        },
      ),
    );
  }
}
