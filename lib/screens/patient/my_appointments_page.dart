import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/thema.dart';

class MyAppointmentsPage extends StatefulWidget {
  const MyAppointmentsPage({super.key});

  @override
  State<MyAppointmentsPage> createState() => _MyAppointmentsPageState();
}

class _MyAppointmentsPageState extends State<MyAppointmentsPage> {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> _cancelBooking(String bookingId, String doctorId, String dateKey, String time) async {
    try {
      // 1. Get current doctor data to update bookings map
      final doctorData = await _supabase.from('doctors').select('bookings').eq('id', doctorId).single();
      final Map<String, dynamic> bookings = Map<String, dynamic>.from(doctorData['bookings'] ?? {});

      // 2. Remove the time slot locally
      final times = List<String>.from(bookings[dateKey] ?? []);
      times.remove(time);
      if (times.isEmpty) {
        bookings.remove(dateKey);
      } else {
        bookings[dateKey] = times;
      }

      // 3. Update doctor bookings
      await _supabase.from('doctors').update({'bookings': bookings}).eq('id', doctorId);

      // 4. Delete the appointment record
      await _supabase.from('appointments').delete().eq('id', bookingId);

    } catch (e) {
      debugPrint("Error cancelling booking: $e");
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking canceled')),
    );
  }

  void _confirmCancel(String bookingId, String doctorId, String dateKey, String time) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: const Text('Are you sure you want to cancel this appointment?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kPrimary),
            onPressed: () {
              Navigator.pop(context);
              _cancelBooking(bookingId, doctorId, dateKey, time);
            },
            child: const Text('Yes, cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = _supabase.auth.currentUser?.id;

    if (userId == null) {
      return const Scaffold(body: Center(child: Text("Please log in first.")));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Appointments')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _supabase
            .from('appointments')
            .stream(primaryKey: ['id'])
            .eq('userId', userId)
            .order('date', ascending: true), // Assuming column name is 'date' based on Booking model
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No appointments yet'));
          }

          final docs = snapshot.data!;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, idx) {
              final b = docs[idx];
              final bookingId = b['id'].toString();
              final doctorId = b['doctorId'] as String;
              final doctorName = b['doctorName'] as String;
              final dateKey = b['date'] as String; // Column name 'date'
              final time = b['time'] as String;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.calendar_month),
                  title: Text(doctorName),
                  subtitle: Text('$dateKey • $time'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmCancel(bookingId, doctorId, dateKey, time),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
