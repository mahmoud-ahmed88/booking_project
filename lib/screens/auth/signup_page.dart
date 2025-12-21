import 'package:flutter/material.dart';
import '../../core/thema.dart';
import 'role_selection_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _signup() {
    // demo-only: go to role selection
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const RoleSelectionPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              TextField(
                  controller: _name,
                  decoration: const InputDecoration(
                      labelText: 'Full Name', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(
                  controller: _email,
                  decoration: const InputDecoration(
                      labelText: 'Email', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(
                  controller: _pass,
                  decoration: const InputDecoration(
                      labelText: 'Password', border: OutlineInputBorder()),
                  obscureText: true),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: _signup,
                    style: ElevatedButton.styleFrom(backgroundColor: kPrimary),
                    child: const Text('Sign Up')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}