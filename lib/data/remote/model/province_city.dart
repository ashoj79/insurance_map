class ProvinceAndCity {
  final int id;
  final String name;
  final double lat, lng;
  ProvinceAndCity.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        lat = double.parse(data['latitude'] ?? '0'),
        lng = double.parse(data['longitude'] ?? '0');
}
