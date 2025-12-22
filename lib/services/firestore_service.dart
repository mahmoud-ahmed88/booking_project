import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/booking.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addBooking(Booking booking) async {
    await _db.collection('appointments').add({
      'doctorId': booking.doctorId,
      'doctorName': booking.doctorName,
      'date': booking.dateKey,
      'time': booking.time,
      'userId': booking.userId,
    });
  }

  /// Creates or updates a user document in the 'users' collection.
  Future<void> setUserRole(String role) async {
    final user = _auth.currentUser;
    if (user == null) {
      // This should ideally not be reached if called after login/signup
      throw Exception("No authenticated user found.");
    }

    // Set user data in a 'users' collection document, identified by user's UID
    await _db.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true)); // Use merge to avoid overwriting other fields
  }

  Stream<QuerySnapshot> getBookings() {
    return _db.collection('appointments').snapshots();
  }
}
