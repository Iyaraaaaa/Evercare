import 'package:flutter/material.dart';
import 'payment.dart'; // Import the PaymentPage

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  Map<String, bool> appointmentStatus = {}; // Track appointments

  List<Map<String, String>> patients = [
    {
      'id': 'P001',
      'name': 'John Doe',
      'phone': '123-456-7890',
      'address': '123 Elm St, Springfield',
      'department': 'Cardiology',
      'doctor': 'Dr. Smith',
      'doctorId': 'D101',
      'gender': 'Male',
      'image': 'assets/images/men.jpg',
    },
    {
      'id': 'P002',
      'name': 'Jane Doe',
      'phone': '234-567-8901',
      'address': '456 Oak St, Springfield',
      'department': 'Neurology',
      'doctor': 'Dr. Brown',
      'doctorId': 'D102',
      'gender': 'Female',
      'image': 'assets/images/women.jpg',
    },
  ];

  void _toggleAppointment(String id) {
    setState(() {
      appointmentStatus[id] = !(appointmentStatus[id] ?? false);
    });
  }

  void _navigateToPayment(BuildContext context, String patientName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(patientName: patientName),
      ),
    );
  }

  // Override the back button to navigate to HomePage instead
  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Placeholder()), // Replace with a placeholder or actual HomePage
    );
    return false; // Prevent default back navigation
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Intercept the back button press
      child: Scaffold(
        appBar: AppBar(
          title: Text('Schedule'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => _onWillPop(), // Override the back button press
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              var patient = patients[index];
              bool isScheduled = appointmentStatus[patient['id']] ?? false;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(patient['image']!),
                            radius: 30,
                          ),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(patient['name']!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18)),
                              Text('Patient ID: ${patient['id']}'),
                              Text('Phone: ${patient['phone']}'),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Text('Address: ${patient['address']}'),
                      Text('Department: ${patient['department']}'),
                      Text('Doctor: ${patient['doctor']}'),
                      Text('Doctor ID: ${patient['doctorId']}'),
                      Text('Gender: ${patient['gender']}'),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () => _toggleAppointment(patient['id']!),
                            child: Text(
                              isScheduled
                                  ? 'Cancel Appointment'
                                  : 'Schedule Appointment',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isScheduled
                                  ? Colors.red.shade900
                                  : Colors.blue.shade900, // Darker colors
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () =>
                                _navigateToPayment(context, patient['name']!),
                            child: Text(
                              'Make Payment',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade900, // Dark Green
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
