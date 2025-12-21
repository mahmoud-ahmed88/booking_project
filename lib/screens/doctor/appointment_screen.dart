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
  List<String> prescriptions = [];
  List<String> notes = [];

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
              color: lightBlue.withAlpha((0.1 * 255).round()),
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
          backgroundColor: color.withAlpha((0.15 * 255).round()),
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
      onTap: () => _openEditor(title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 120,
        decoration: BoxDecoration(
        color: selected ? lightBlue.withAlpha((0.2 * 255).round()) : Colors.white,
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

  void _openEditor(String title) {
    setState(() => selectedBox = title);
    final entries = title == 'Prescriptions' ? prescriptions : notes;
    final TextEditingController ctl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom, top: 12, left: 12, right: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    icon: const Icon(Icons.close))
              ],
            ),
            const SizedBox(height: 8),
            if (entries.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('No items yet.'),
              )
            else
              SizedBox(
                height: 150,
                child: ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (_, i) => ListTile(
                          title: Text(entries[i]),
                          trailing: IconButton(
                              onPressed: () {
                                setState(() => entries.removeAt(i));
                                // rebuild sheet
                                (ctx as Element).markNeedsBuild();
                              },
                              icon: const Icon(Icons.delete, color: Colors.red)),
                        )),
              ),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: ctl,
                  decoration: InputDecoration(
                      hintText: 'Add new ${title.toLowerCase()}', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                  onPressed: () {
                    final text = ctl.text.trim();
                    if (text.isEmpty) return;
                    setState(() => entries.add(text));
                    ctl.clear();
                    (ctx as Element).markNeedsBuild();
                  },
                  child: const Text('Add'))
            ]),
            const SizedBox(height: 12),
          ],
        ),
      ),
    ).whenComplete(() {
      setState(() => selectedBox = '');
    });
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
              color: Colors.black.withAlpha((0.03 * 255).round()),
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