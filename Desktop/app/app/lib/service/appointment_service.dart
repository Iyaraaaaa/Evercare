import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to save appointment data
  Future<void> saveAppointmentData({
    required String selectedDoctorId,
    required String selectedHospital,
    required String selectedSpecialization,
    required DateTime selectedDate,
    required String userId,
    required String userPhoneNumber,
    required String userName,
    required String userGender,
  }) async {
    try {
      // Create the appointment data map
      final appointmentData = {
        'userId': userId, // User's UID from Firebase Auth
        'doctorId': selectedDoctorId, // Selected doctor ID
        'hospital': selectedHospital, // Selected hospital
        'specialization': selectedSpecialization, // Selected specialization
        'appointmentDate': selectedDate, // Selected appointment date
        'userPhoneNumber': userPhoneNumber, // User's phone number
        'userName': userName, // User's name
        'userGender': userGender, // User's gender
        'status': 'Scheduled', // Status of the appointment
        'createdAt': FieldValue.serverTimestamp(), // Timestamp of creation
      };

      // Save the data to the 'appointments' collection in Firestore
      await _firestore.collection('appointments').add(appointmentData);

      print('Appointment scheduled successfully.');
    } catch (e) {
      print('Error scheduling appointment: $e');
      rethrow; // Rethrow the error for handling in the UI
    }
  }

  // Method to fetch appointments for a specific user
  Future<List<Map<String, dynamic>>> getAppointmentsForUser(String userId) async {
    try {
      // Query the 'appointments' collection for documents where 'userId' matches
      final querySnapshot = await _firestore
          .collection('appointments')
          .where('userId', isEqualTo: userId)
          .get();

      // Convert the documents to a list of maps
      final appointments = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id, // Document ID
          ...doc.data(), // Spread the document data
        };
      }).toList();

      return appointments;
    } catch (e) {
      print('Error fetching appointments: $e');
      rethrow; // Rethrow the error for handling in the UI
    }
  }

  // Method to update appointment status
  Future<void> updateAppointmentStatus({
    required String appointmentId,
    required String newStatus,
  }) async {
    try {
      // Update the 'status' field of the appointment document
      await _firestore
          .collection('appointments')
          .doc(appointmentId)
          .update({'status': newStatus});

      print('Appointment status updated successfully.');
    } catch (e) {
      print('Error updating appointment status: $e');
      rethrow; // Rethrow the error for handling in the UI
    }
  }

  // Method to delete an appointment
  Future<void> deleteAppointment(String appointmentId) async {
    try {
      // Delete the appointment document
      await _firestore.collection('appointments').doc(appointmentId).delete();

      print('Appointment deleted successfully.');
    } catch (e) {
      print('Error deleting appointment: $e');
      rethrow; // Rethrow the error for handling in the UI
    }
  }
}