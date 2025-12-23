import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/booking.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addBooking(Booking booking) async {
    await _firestore.collection('appointments').add(booking.toMap());
  }

  /// Creates or updates a user document in the 'users' collection.
  Future<void> updateUserRole(String role) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("No authenticated user found.");
    }

    await _firestore.collection('users').doc(user.uid).update({
      'role': role,
    });
  }

  /// Creates a user document in the 'users' collection.
  Future<void> createUser(User user, String name) async {
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'name': name,
      'email': user.email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Booking>> getBookings() {
    return _firestore.collection('appointments').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Booking.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }
}
