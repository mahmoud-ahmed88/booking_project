import 'package:flutter/material.dart';
import '../auth/role_selection_page.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final Color darkBlue = const Color(0xFF0D1E4A);
  final Color lightBlue = const Color(0xFF4F7CFF);

  String selectedAction = "";
  Color selectedColor = Colors.transparent;

  String selectedBox = "";
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: lightBlue,
            onPressed: () => Navigator.pop(context)),
        title: const Text("Appointment Details"),
        actions: [
          IconButton(
            tooltip: 'Role selection',
            icon: const Icon(Icons.swap_horiz),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const RoleSelectionPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: lightBlue.withOpacity(.1),
                borderRadius: BorderRadius.circular(16)),
            child: Center(
                child: Text("Wed, 12 May 24 | 11:30 PM",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: darkBlue))),
          ),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _actionButton(Icons.check_circle, "Completed", Colors.green),
            _actionButton(Icons.delete, "Cancel", Colors.red),
            _actionButton(Icons.access_time, "Reschedule", Colors.orange),
          ]),
          const SizedBox(height: 12),
          if (selectedAction.isNotEmpty)
            Text("You selected: $selectedAction",
                style: TextStyle(
                    color: selectedColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          const SizedBox(height: 25),
          _sectionTitle("Patient Information"),
          _infoCard(),
          const SizedBox(height: 22),
          _sectionTitle("Prescriptions & Notes"),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _selectBox("Prescriptions")),
            const SizedBox(width: 12),
            Expanded(child: _selectBox("Notes"))
          ]),
          const SizedBox(height: 12),
          if (selectedBox.isNotEmpty)
            Text("$selectedBox selected",
                style:
                    TextStyle(color: lightBlue, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: isSaved ? Colors.green : darkBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18))),
              onPressed: () {
                setState(() {
                  isSaved = true;
                });
              },
              child: Text(isSaved ? "Done ✅" : "Save Appointment",
                  style: const TextStyle(fontSize: 16)),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(text,
            style: TextStyle(
                fontSize: 20, color: darkBlue, fontWeight: FontWeight.bold)));
  }

  Widget _actionButton(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAction = label;
          selectedColor = color;
        });
      },
      child: Column(children: [
        CircleAvatar(
            backgroundColor: color.withOpacity(.15),
            radius: 26,
            child: Icon(icon, color: color, size: 26)),
        const SizedBox(height: 6),
        Text(label,
            style: TextStyle(color: darkBlue, fontWeight: FontWeight.w600))
      ]),
    );
  }

  Widget _selectBox(String title) {
    bool selected = selectedBox == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedBox = title;
        });
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              selectedBox = "";
            });
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 120,
        decoration: BoxDecoration(
            color: selected ? lightBlue.withOpacity(.2) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: selected ? lightBlue : Colors.grey.shade300, width: 2)),
        child: Center(
            child: Text(title,
                style: TextStyle(
                    color: selected ? lightBlue : darkBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold))),
      ),
    );
  }

  Widget _infoCard() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.03),
                blurRadius: 8,
                offset: const Offset(0, 4))
          ]),
      child: Column(children: [
        _detailRow("Name", "Tasneem Ibrahim"),
        _detailRow("Age", "26"),
        _detailRow("Gender", "Female"),
        _detailRow("Phone", "01598563214"),
        _detailRow("Address", "Assiut"),
        _detailRow("History", "No")
      ]),
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Expanded(child: Text(title, style: TextStyle(color: darkBlue))),
        Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)))
      ]),
    );
  }
}