import 'package:flutter/material.dart';
import '../../data/fake_data.dart';
import '../auth/role_selection_page.dart';
import 'my_appointments_page.dart';
import 'doctor_profile_page.dart';

class DoctorListPage extends StatelessWidget {
  const DoctorListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const RoleSelectionPage()),
            );
          },
        ),
        title: const Text('Available Doctors'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const MyAppointmentsPage()));
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: gDoctors.length,
        itemBuilder: (context, idx) {
          final d = gDoctors[idx];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(d.name),
              subtitle: Text("${d.specialty} • ${d.price}"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DoctorProfilePage(doctor: d)));
              },
            ),
          );
        },
      ),
    );
  }
}