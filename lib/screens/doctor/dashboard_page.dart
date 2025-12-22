import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../settings/settings_page.dart';
import '../doctor/appointment_screen.dart';
import '../auth/role_selection_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  ModalRoute<dynamic>? _route;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> _onWillPop() async {
    if (!mounted) return true;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RoleSelectionPage()),
    );
    return false;
  }

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (_route != route) {
      // ignore: deprecated_member_use
      _route?.removeScopedWillPopCallback(_onWillPop);
      _route = route;
      // ignore: deprecated_member_use
      _route?.addScopedWillPopCallback(_onWillPop);
    }
  }

  @override
  void dispose() {
    // ignore: deprecated_member_use
    _route?.removeScopedWillPopCallback(_onWillPop);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uid = _auth.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const RoleSelectionPage()),
                  );
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
            Row(children: [
              const CircleAvatar(
                  radius: 32,
                  backgroundColor: Color(0xFFE6EEFF),
                  child: Icon(Icons.person, size: 30, color: Color(0xFF1E40AF))),
              const SizedBox(width: 12),
              Text("Welcome, Dr. User",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ]),
            const SizedBox(height: 20),
            _title("Upcoming Appointments"),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('users')
                  .doc(uid)
                  .collection('appointments')
                  .orderBy('date')
                  .limit(5)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Text("No upcoming appointments.");
                }
                return Column(
                  children: docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return _appointmentItem(
                      data['patientName'] ?? 'Unknown',
                      data['time'] ?? '',
                      Icons.person,
                      context,
                      doc.id,
                    );
                  }).toList(),
                );
              },
            ),
            _title("Recent Invoices"),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('users')
                  .doc(uid)
                  .collection('invoices')
                  .orderBy('date', descending: true)
                  .limit(5)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Text("No recent invoices.");
                }
                return Column(
                  children: docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return _invoiceItem(
                        data['patientName'] ?? 'Unknown',
                        data['amount']?.toString() ?? '\$0.00',
                        Icons.person);
                  }).toList(),
                );
              },
            ),
          ]),
        ),
      ),
    );
  }

  Widget _appointmentItem(String name, String time, IconData icon,
      BuildContext context, String docId) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AppointmentScreen(appointmentId: docId)));
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
                const Text("Invoice",
                    style: TextStyle(color: Colors.black54))
              ])),
          Text(amount,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
        ]),
      ),
    );
  }
}
