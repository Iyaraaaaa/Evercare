import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(DoctorApp());
}

class DoctorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DoctorHomePage(),
    );
  }
}

class DoctorHomePage extends StatefulWidget {
  @override
  _DoctorHomePageState createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  String? selectedHospital;
  String? selectedDoctorId;
  DateTime? selectedDate;
  String? userPhoneNumber;
  String? userName;
  String? userGender;

  final List<String> hospitals = ["Colombo", "Gampaha", "Kurunagela"];
  final List<String> genders = ["Male", "Female"]; // Gender options

  // Doctor Data
  final List<Map<String, dynamic>> doctors = [
    {
      'name': 'Dr. Anjana Imesh',
      'id': 'D001',
      'image': 'assets/images/doctor1.jpg',
    },
    {
      'name': 'Dr. Sithmi Iyara',
      'id': 'D002',
      'image': 'assets/images/doctor2.jpg',
    },
    {
      'name': 'Dr. Dulmini Navanjana',
      'id': 'D003',
      'image': 'assets/images/doctor3.jpg',
    },
    {
      'name': 'Dr. Binath Wanigarathna',
      'id': 'D004',
      'image': 'assets/images/doctor4.jpg',
    },
  ];

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _scheduleAppointment() {
    if (selectedHospital == null ||
        selectedDoctorId == null ||
        selectedDate == null ||
        userPhoneNumber == null ||
        userPhoneNumber!.isEmpty ||
        userName == null ||
        userName!.isEmpty ||
        userGender == null ||
        userGender!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    // Save the appointment data to Firestore
    saveAppointmentData();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Appointment scheduled successfully!")),
    );
  }

  Future<void> saveAppointmentData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final appointmentData = {
        'userId': user.uid, // Current user's ID
        'doctorId': selectedDoctorId, // Selected doctor's ID
        'hospital': selectedHospital, // Selected hospital
        'appointmentDate': selectedDate, // Selected date
        'userPhoneNumber': userPhoneNumber, // User's phone number
        'userName': userName, // User's name
        'userGender': userGender, // User's gender
        'status': 'Scheduled', // Default status
        'createdAt': FieldValue.serverTimestamp(), // Timestamp of creation
      };

      // Save data to Firestore in the 'appointments' collection
      await FirebaseFirestore.instance.collection('appointments').add(appointmentData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/home.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground Content
          Center(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(12),
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "🔎 Channel Your Doctor",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  SizedBox(height: 16),

                  // Hospital Dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "🏥 Select Hospital",
                      border: OutlineInputBorder(),
                    ),
                    items: hospitals.map((hospital) {
                      return DropdownMenuItem(
                        value: hospital,
                        child: Text(hospital),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedHospital = value;
                      });
                    },
                  ),
                  SizedBox(height: 10),

                  // Doctor Selection
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "👨‍⚕ Select Doctor",
                      border: OutlineInputBorder(),
                    ),
                    items: doctors.map((doctor) {
                      return DropdownMenuItem<String>(
                        value: doctor['id'],
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(doctor['image']),
                              radius: 20,
                            ),
                            SizedBox(width: 10),
                            Text(doctor['name']),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDoctorId = value;
                      });
                    },
                  ),
                  SizedBox(height: 10),

                  // Date Picker
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "📅 Select Date",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () => _selectDate(context),
                    controller: TextEditingController(
                      text: selectedDate != null ? "${selectedDate!.toLocal()}".split(' ')[0] : "",
                    ),
                  ),
                  SizedBox(height: 10),

                  // Name Input
                  TextField(
                    decoration: InputDecoration(
                      labelText: "👤 Your Name",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        userName = value;
                      });
                    },
                  ),
                  SizedBox(height: 10),

                  // Gender Dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "🚻 Your Gender",
                      border: OutlineInputBorder(),
                    ),
                    items: genders.map((gender) {
                      return DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        userGender = value;
                      });
                    },
                  ),
                  SizedBox(height: 10),

                  // Phone Number Input
                  TextField(
                    decoration: InputDecoration(
                      labelText: "📱 Your Phone Number",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        userPhoneNumber = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),

                  // Schedule Appointment Button
                  ElevatedButton.icon(
                    onPressed: _scheduleAppointment,
                    icon: Icon(Icons.calendar_today, color: Colors.white),
                    label: Text(
                      "Schedule Appointment",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Blue button
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}