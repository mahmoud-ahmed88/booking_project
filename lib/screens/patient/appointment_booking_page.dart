import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/doctor.dart';
import '../../models/booking.dart';
import '../../core/thema.dart';
import '../../services/firestore_service.dart';

class AppointmentBookingPage extends StatefulWidget {
  final Doctor doctor;
  const AppointmentBookingPage({super.key, required this.doctor});

  @override
  State<AppointmentBookingPage> createState() =>
      _AppointmentBookingPageState();
}

class _AppointmentBookingPageState extends State<AppointmentBookingPage> {
  DateTime selectedDate = DateTime.now();
  final List<String> times = [
    "09:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "02:00 PM",
    "03:00 PM",
    "04:00 PM"
  ];
  int selectedIndex = -1;

  String get dateKey =>
      "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment')),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: kPrimary),
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text('Date: $dateKey'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedDate = DateTime.now();
                      selectedIndex = -1;
                    });
                  },
                  icon: const Icon(Icons.refresh),
                )
              ],
            ),
            const SizedBox(height: 14),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Time',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                itemCount: times.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.6,
                ),
                itemBuilder: (context, idx) {
                  final time = times[idx];
                  final booked =
                      widget.doctor.isBooked(dateKey, time);
                  final selected = selectedIndex == idx;

                  return GestureDetector(
                    onTap: booked
                        ? null
                        : () {
                            setState(() => selectedIndex = idx);
                          },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: booked
                            ? Colors.red.shade300
                            : selected
                                ? kPrimary
                                : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        time,
                        style: TextStyle(
                          color: booked || selected
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: kPrimary),
                onPressed:
                    selectedIndex == -1 ? null : _confirmBooking,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Confirm Booking'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.isBefore(now) ? now : selectedDate,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        selectedIndex = -1;
      });
    }
  }

  Future<void> _confirmBooking() async {
    final time = times[selectedIndex];
    final key = dateKey;

    if (widget.doctor.isBooked(key, time)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('This time was just booked. Choose another.'),
        ),
      );
      setState(() => selectedIndex = -1);
      return;
    }

    // Local booking state
    widget.doctor.book(key, time);

    final booking = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      doctorId: widget.doctor.id,
      doctorName: widget.doctor.name,
      dateKey: key,
      time: time,
      userId: _auth.currentUser?.uid ?? '',
    );

    try {
      await FirestoreService().addBooking(booking); // 🔥 Firebase
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Appointment Confirmed ✅'),
          content: Text(
            'Doctor: ${widget.doctor.name}\nDate: $key\nTime: $time',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save booking: $e')),
        );
      }
    }
  }
}
