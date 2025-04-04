import 'package:flutter/material.dart';
import 'message.dart'; // Import the message page

class DoctorPage extends StatelessWidget {
  final List<Map<String, String>> doctors = [
    {
      'name': 'Dr. Anjana Imesh',
      'id': 'D001',
      'field': 'Cardiology',
      'phone': '+1 234 567 890',
      'email': '40-ict-0031@outlook.com',
      'fb': 'https://www.facebook.com/share/16GEgPg9sT/',
      'image': 'assets/images/doctor1.jpg',
    },
    {
      'name': 'Dr. Sithmi Iyara',
      'id': 'D002',
      'field': 'Neurology',
      'phone': '+1 345 678 901',
      'email': '40-ict-0027@outlook.com',
      'fb': 'https://www.facebook.com/share/1EEJFLcyLo/',
      'image': 'assets/images/doctor2.jpg',
    },
    {
      'name': 'Dr. Dulmini Navanjana',
      'id': 'D003',
      'field': 'Cardiology',
      'phone': '+1 234 567 890',
      'email': '40-ict-0014@outlook.com',
      'fb': 'https://www.instagram.com/dulmini_',
      'image': 'assets/images/doctor3.jpg',
    },
    {
      'name': 'Dr. Binath Wanigarathna',
      'id': 'D004',
      'field': 'Neurology',
      'phone': '+1 345 678 901',
      'email': '40-ict-0028@outlook.com',
      'fb': 'https://www.facebook.com/share/19CeDqa9zF/',
      'image': 'assets/images/doctor4.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Online Doctors List
          Container(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doctor = doctors[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(doctor['image']!),
                      ),
                      Positioned(
                        right: 5,
                        bottom: 5,
                        child: CircleAvatar(
                          radius: 6,
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Doctor Chat List
          Expanded(
            child: ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doctor = doctors[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(doctor['image']!),
                  ),
                  title: Text(
                    doctor['name']!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Hello, Doctor, are you there? asd as d asd asd asd as d s"),
                  trailing: Text("12:30"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessagePage(doctor: doctor),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}