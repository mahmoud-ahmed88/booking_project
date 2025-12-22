import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/thema.dart';

class MyAppointmentsPage extends StatefulWidget {
  const MyAppointmentsPage({super.key});

  @override
  State<MyAppointmentsPage> createState() => _MyAppointmentsPageState();
}

class _MyAppointmentsPageState extends State<MyAppointmentsPage> {
  Future<void> _cancelBooking(String bookingId, String doctorId, String dateKey, String time) async {
    final docRef = FirebaseFirestore.instance.collection('doctors').doc(doctorId);

    // Remove booking from doctor's document
    await FirebaseFirestore.instance.runTransaction((txn) async {
      final docSnap = await txn.get(docRef);
      if (!docSnap.exists) return;

      final data = docSnap.data()!;
      final bookings = Map<String, dynamic>.from(data['bookings'] ?? {});

      final times = List<String>.from(bookings[dateKey] ?? []);
      times.remove(time);
      if (times.isEmpty) {
        bookings.remove(dateKey);
      } else {
        bookings[dateKey] = times;
      }

      txn.update(docRef, {'bookings': bookings});
      txn.delete(FirebaseFirestore.instance.collection('bookings').doc(bookingId));
    });

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
    final userId = "CURRENT_USER_ID"; // 🔹 استبدلها بالـ Firebase Auth user ID

    return Scaffold(
      appBar: AppBar(title: const Text('My Appointments')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('userId', isEqualTo: userId)
            .orderBy('dateKey')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No appointments yet'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, idx) {
              final b = docs[idx].data() as Map<String, dynamic>;
              final bookingId = docs[idx].id;
              final doctorId = b['doctorId'] as String;
              final doctorName = b['doctorName'] as String;
              final dateKey = b['dateKey'] as String;
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
