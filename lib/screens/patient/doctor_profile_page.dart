import 'package:flutter/material.dart';
import '../../models/doctor.dart';
import '../patient/appointment_booking_page.dart';
import '../../core/thema.dart';
import '../../widget/pay_button.dart';

class DoctorProfilePage extends StatelessWidget {
  final Doctor doctor;
  const DoctorProfilePage({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(doctor.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const SizedBox(height: 12),
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 14),
            Text(doctor.name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(doctor.specialty, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12)),
              child: Text("Consultation Fee: ${doctor.price}",
                  style: const TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12)),
              child: Text(doctor.bio),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              AppointmentBookingPage(doctor: doctor)));
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text('Book Appointment'),
                style: ElevatedButton.styleFrom(backgroundColor: kPrimary),
              ),
            ),
            const SizedBox(height: 10),
            PayButton(amount: doctor.price),
          ],
        ),
      ),
    );
  }
}