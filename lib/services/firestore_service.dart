import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/booking.dart';

class FirestoreService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> addBooking(Booking booking) async {
    await _supabase.from('appointments').insert({
      'doctorId': booking.doctorId,
      'doctorName': booking.doctorName,
      'date': booking.dateKey,
      'time': booking.time,
      'userId': booking.userId,
    });
  }

  /// Creates or updates a user document in the 'users' collection.
  Future<void> setUserRole(String role) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      // This should ideally not be reached if called after login/signup
      throw Exception("No authenticated user found.");
    }

    // Set user data in a 'users' collection document, identified by user's UID
    await _supabase.from('users').upsert({
      'uid': user.id,
      'email': user.email,
      'displayName': user.userMetadata?['displayName'],
      'role': role,
      'createdAt': DateTime.now().toIso8601String(),
    }); 
  }

  Stream<List<Booking>> getBookings() {
    return _supabase.from('appointments').stream(primaryKey: ['id']).map((data) {
      return data.map((item) => Booking.fromMap(item)).toList();
    });
  }
}
