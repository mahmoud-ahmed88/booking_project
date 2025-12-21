class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String bio;
  final String price;
  final Map<String, List<String>> booked; // key: yyyy-m-d

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.bio,
    required this.price,
    Map<String, List<String>>? booked,
  }) : booked = booked ?? {};

  bool isBooked(String dateKey, String time) =>
      booked[dateKey]?.contains(time) ?? false;

  void book(String dateKey, String time) {
    booked.putIfAbsent(dateKey, () => []);
    if (!booked[dateKey]!.contains(time)) booked[dateKey]!.add(time);
  }

  void cancel(String dateKey, String time) {
    booked[dateKey]?.remove(time);
    if (booked[dateKey]?.isEmpty ?? false) booked.remove(dateKey);
  }
}

