import 'package:flutter/material.dart';
import '../../data/fake_data.dart';
import '../../models/booking.dart';
import '../../core/thema.dart';

class MyAppointmentsPage extends StatefulWidget {
  const MyAppointmentsPage({super.key});

  @override
  State<MyAppointmentsPage> createState() => _MyAppointmentsPageState();
}

class _MyAppointmentsPageState extends State<MyAppointmentsPage> {
  void _cancelBooking(Booking b) {
    final doc = gDoctors.firstWhere((d) => d.id == b.doctorId);
    doc.cancel(b.dateKey, b.time);
    gMyBookings.removeWhere((x) => x.id == b.id);
    setState(() {});
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Booking canceled')));
  }

  @override
  Widget build(BuildContext context) {
    final sorted = List<Booking>.from(gMyBookings)
      ..sort((a, b) => a.dateKey.compareTo(b.dateKey));
    return Scaffold(
      appBar: AppBar(title: const Text('My Appointments')),
      body: sorted.isEmpty
          ? const Center(child: Text('No appointments yet'))
          : ListView.builder(
              itemCount: sorted.length,
              itemBuilder: (context, idx) {
                final b = sorted[idx];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.calendar_month),
                    title: Text(b.doctorName),
                    subtitle: Text('${b.dateKey} • ${b.time}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmCancel(b),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _confirmCancel(Booking b) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content:
            const Text('Are you sure you want to cancel this appointment?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('No')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kPrimary),
            onPressed: () {
              Navigator.pop(context);
              _cancelBooking(b);
            },
            child: const Text('Yes, cancel'),
          )
        ],
      ),
    );
  }
}