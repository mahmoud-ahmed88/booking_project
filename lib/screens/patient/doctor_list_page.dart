import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth/role_selection_page.dart';
import 'my_appointments_page.dart';
import 'doctor_profile_page.dart';
import '../../models/doctor.dart';

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
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: Supabase.instance.client.from('doctors').stream(primaryKey: ['id']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No doctors found."));
          }

          final docs = snapshot.data!;
          final doctors = docs.map((data) {
            return Doctor(
              id: data['id'].toString(),
              name: data['name'] ?? 'Unnamed',
              specialty: data['specialty'] ?? 'General',
              price: data['price']?.toString() ?? '0',
              bookings: data['bookings'] != null
                  ? Map<String, List<String>>.from(data['bookings'])
                  : {},
            );
          }).toList();

          return ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (context, idx) {
              final d = doctors[idx];
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          );
        },
      ),
    );
  }
}
