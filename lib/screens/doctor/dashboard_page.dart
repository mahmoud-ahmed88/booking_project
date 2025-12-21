import 'package:flutter/material.dart';
import '../settings/settings_page.dart';
import 'appointment_screen.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Widget _title(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(text,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2A37))),
    );
  }

  Widget _appointmentItem(
      String name, String time, IconData icon, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const AppointmentScreen()));
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFE6EEFF),
                child: Icon(icon, size: 24, color: Colors.blue.shade800)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    Text(time,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 14)),
                  ]),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue.shade800,
                  borderRadius: BorderRadius.circular(10)),
              child: const Text("Book",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  Widget _invoiceItem(String name, String amount, IconData icon) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFFE6EEFF),
              child: Icon(icon, size: 24, color: Colors.blue.shade800)),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold)),
                const Text("Invoice #1204",
                    style: TextStyle(color: Colors.black54))
              ])),
          Text(amount,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.black),
              ),
              const Text("Docline",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SettingsPage()));
                },
                icon: const Icon(Icons.settings, size: 28, color: Colors.blue),
              )
            ]),
            const SizedBox(height: 15),
            Row(children: const [
              CircleAvatar(
                  radius: 32,
                  backgroundColor: Color(0xFFE6EEFF),
                  child:
                      Icon(Icons.person, size: 30, color: Color(0xFF1E40AF))),
              SizedBox(width: 12),
              Text("Welcome, Dr. Ahmed",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ]),
            const SizedBox(height: 20),
            _title("Upcoming Appointments"),
            _appointmentItem("Omar Mohamed", "10:00 AM", Icons.person, context),
            _appointmentItem(
                "Tasneem Ibrahim", "11:30 AM", Icons.person, context),
            _appointmentItem(
                "Abdelrhman Amged", "2:00 PM", Icons.person, context),
            _title("Recent Invoices"),
            _invoiceItem("Omar Mohamed", "\$250.00", Icons.person),
            _invoiceItem("Abdelrhman Amged", "\$190.00", Icons.person),
          ]),
        ),
      ),
    );
  }
}