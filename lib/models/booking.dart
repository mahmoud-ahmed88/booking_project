import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String? id;
  final String doctorId;
  final String doctorName;
  final String patientId;
  final String? patientEmail;
  final String date; // Stored as ISO 8601 String
  final String status;

  Booking({
    this.id,
    required this.doctorId,
    required this.doctorName,
    required this.patientId,
    this.patientEmail,
    required this.date,
    required this.status,
  });

  factory Booking.fromMap(Map<String, dynamic> map, String documentId) {
    return Booking(
      id: documentId,
      doctorId: map['doctorId'] ?? '',
      doctorName: map['doctorName'] ?? '',
      patientId: map['patientId'] ?? '',
      patientEmail: map['patientEmail'],
      date: map['date'] ?? '',
      status: map['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'doctorName': doctorName,
      'patientId': patientId,
      'patientEmail': patientEmail,
      'date': date,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(), // Add this on creation
    };
  }
}