import 'package:flutter/material.dart';
import '../doctor/dashboard_page.dart';
import '../patient/doctor_list_page.dart';
import 'login_page.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  bool flashDoctor = false;
  bool flashPatient = false;

  void _flash(VoidCallback on, VoidCallback off) {
    on();
    Future.delayed(const Duration(milliseconds: 140), off);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Center(
                  child: Text('Welcome to DocLine',
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold))),
              const SizedBox(height: 10),
              const Text('Please select your role to continue',
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  _flash(() => setState(() => flashDoctor = true),
                      () => setState(() => flashDoctor = false));
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const DashboardPage()));
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                        color: flashDoctor
                          ? Colors.blueAccent.withAlpha((0.8 * 255).round())
                          : Colors.blueAccent,
                      borderRadius: BorderRadius.circular(12)),
                  child: const Center(
                      child: Text("I'm a Doctor",
                          style: TextStyle(color: Colors.white, fontSize: 18))),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _flash(() => setState(() => flashPatient = true),
                      () => setState(() => flashPatient = false));
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const DoctorListPage()));
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                      color:
                          flashPatient ? Colors.green.shade700 : Colors.green,
                      borderRadius: BorderRadius.circular(12)),
                  child: const Center(
                      child: Text("I'm a Patient",
                          style: TextStyle(color: Colors.white, fontSize: 18))),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const LoginPage()));
                },
                child: const Text('Back to Login'),
              )
            ],
          ),
        ),
      ),
    );
  }
}