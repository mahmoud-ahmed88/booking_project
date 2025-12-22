import 'package:flutter/material.dart';
import '../../core/config/routes/routes.dart';
import '../../core/thema.dart';
import '../../services/firestore_service.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  bool _isLoading = false;
  final FirestoreService _firestoreService = FirestoreService();

  /// Saves the selected role to Firestore and navigates the user.
  Future<void> _selectRole(String role) async {
    setState(() => _isLoading = true);

    try {
      // Call the service to save the user's role
      await _firestoreService.setUserRole(role);

      if (!mounted) return;

      // Navigate to the appropriate home screen based on the role
      final destination =
          role == 'Doctor' ? AppRoutes.doctorHome : AppRoutes.patientHome;
      Navigator.pushReplacementNamed(context, destination);
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save role: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Role'),
        automaticallyImplyLeading: false, // To prevent going back to signup
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'How will you be using this app?',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 40),
                    _roleButton(
                      context,
                      icon: Icons.local_hospital,
                      label: "I'm a Doctor",
                      onTap: () => _selectRole('Doctor'),
                    ),
                    const SizedBox(height: 20),
                    _roleButton(
                      context,
                      icon: Icons.person,
                      label: "I'm a Patient",
                      onTap: () => _selectRole('Patient'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _roleButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 28),
      label: Text(label, style: const TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}