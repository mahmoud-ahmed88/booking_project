import 'package:flutter/material.dart';
import '../../data/fake_data.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const CircleAvatar(radius: 44, child: Icon(Icons.person, size: 44)),
            const SizedBox(height: 14),
            Text(gCurrentUserName ?? 'No name', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(gCurrentUserEmail ?? 'No email', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 18),
            const Text('Profile Info', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('This demo stores the name and email you entered during Sign Up.'),
          ],
        ),
      ),
    );
  }
}
