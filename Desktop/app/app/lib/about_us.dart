import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade900,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildInAppPurchases(),
            Divider(thickness: 1, color: Colors.grey.shade300),
            _buildContactUs(),
            Divider(thickness: 1, color: Colors.grey.shade300),
            _buildAboutUs(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18),
      color: Colors.teal.shade900,
      child: Center(
        child: Text(
          'About EverCare',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildInAppPurchases() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Subscription Plans', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPriceCircle('Free', 'Basic Access'),
              _buildPriceCircle('\$4.99', 'Premium Monthly'),
              _buildPriceCircle('\$49.99', 'Annual Plan'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCircle(String price, String details) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.teal, width: 2),
          ),
          child: Text(price, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
        ),
        SizedBox(height: 6),
        Text(details, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.black87)),
      ],
    );
  }

  Widget _buildContactUs() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: [
          Text('Get in Touch', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            children: [
              _buildContactIcon(Icons.facebook, Colors.blue),
              _buildContactIcon(Icons.email, Colors.redAccent),
              _buildContactIcon(Icons.phone, Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactIcon(IconData icon, Color color) {
    return CircleAvatar(
      radius: 26,
      backgroundColor: color,
      child: Icon(icon, color: Colors.white, size: 30),
    );
  }

  Widget _buildAboutUs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        children: [
          Image.asset('assets/images/background.jpg', height: 100), // Fixed Image Asset
          SizedBox(height: 12),
          Text(
            'EverCare\nYour Trusted Healthcare Companion\nwww.evercare.com',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal.shade800),
          ),
          SizedBox(height: 12),
          Text(
            'EverCare provides top-notch healthcare solutions tailored to your needs. '
            'We are constantly evolving to offer the best services. Stay tuned for updates!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
