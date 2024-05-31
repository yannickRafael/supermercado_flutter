class Vehicle {
  int id;
  String licensePlate;
  String owner;
  DateTime? entryTime;
  DateTime? exitTime;

  Vehicle({required this.id, required this.licensePlate, required this.owner, this.entryTime, this.exitTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'licensePlate': licensePlate,
      'owner': owner,
      'entryTime': entryTime?.toIso8601String(),
      'exitTime': exitTime?.toIso8601String(),
    };
  }
}
