import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/thema.dart';
import '../../widget/pay_button.dart';
import '../patient/appointment_booking_page.dart';
import 'my_appointments_page.dart';
import 'profile_page.dart';
import '../../models/doctor.dart';

class DoctorProfilePage extends StatelessWidget {
  final Doctor? doctor;
  final String? doctorId; // either a Doctor object or an id from Firestore

  const DoctorProfilePage({super.key, this.doctor, this.doctorId})
      : assert(doctor != null || doctorId != null,
            'Provide either a doctor object or a doctorId');

  @override
  Widget build(BuildContext context) {
    if (doctor != null) {
      final d = doctor!;
      return Scaffold(
        appBar: AppBar(
          title: Text(d.name),
          actions: [
            IconButton(
              tooltip: 'Profile',
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ProfilePage()));
              },
            ),
            IconButton(
              tooltip: 'Notifications',
              icon: const Icon(Icons.notifications),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const MyAppointmentsPage()));
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              const SizedBox(height: 12),
              const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
              const SizedBox(height: 14),
              Text(d.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(d.specialty, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
                child: Text("Consultation Fee: ${d.price}",
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
                child: Text(d.bio),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AppointmentBookingPage(doctor: d)));
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Book Appointment'),
                  style: ElevatedButton.styleFrom(backgroundColor: kPrimary),
                ),
              ),
              const SizedBox(height: 10),
              PayButton(amount: d.price),
            ],
          ),
        ),
      );
    }

    // otherwise load from firestore using doctorId
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctorId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: Text("Doctor not found.")),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final d = Doctor(
          id: doctorId ?? '',
          name: data['name'] ?? 'Unnamed',
          specialty: data['specialty'] ?? 'General',
          price: data['price']?.toString() ?? '0',
          bio: data['bio'] ?? '',
          bookings: data['bookings'] != null ? Map<String, List<String>>.from(data['bookings']) : {},
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(d.name),
            actions: [
              IconButton(
                tooltip: 'Profile',
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
                },
              ),
              IconButton(
                tooltip: 'Notifications',
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const MyAppointmentsPage()));
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                const SizedBox(height: 12),
                const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
                const SizedBox(height: 14),
                Text(d.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(d.specialty, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                  decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
                  child: Text("Consultation Fee: ${d.price}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
                  child: Text(d.bio),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => AppointmentBookingPage(doctor: d)));
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Book Appointment'),
                    style: ElevatedButton.styleFrom(backgroundColor: kPrimary),
                  ),
                ),
                const SizedBox(height: 10),
                PayButton(amount: d.price),
              ],
            ),
          ),
        );
      },
    );
  }
}
