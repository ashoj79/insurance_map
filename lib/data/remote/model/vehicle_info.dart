class VehicleInfo {
  final int id;
  final String title;
  VehicleInfo.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'];
}
