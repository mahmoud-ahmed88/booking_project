class Booking {
  final String id;
  final String doctorId;
  final String doctorName;
  final String dateKey;
  final String time;
  final String userId;

  Booking({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.dateKey,
    required this.time,
    required this.userId,
  });

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'].toString(),
      doctorId: map['doctorId'] ?? '',
      doctorName: map['doctorName'] ?? '',
      dateKey: map['date'] ?? '', // لاحظ أن العمود في قاعدة البيانات اسمه date
      time: map['time'] ?? '',
      userId: map['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'doctorName': doctorName,
      'date': dateKey,
      'time': time,
      'userId': userId,
    };
  }
}