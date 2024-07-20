class Vehicle {
  final String id, license;
  Vehicle.fromJson(Map<String, dynamic> data)
    : id = data['id'],
      license = data['license_plate'];
}