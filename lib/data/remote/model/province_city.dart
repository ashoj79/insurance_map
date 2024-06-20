class ProvinceAndCity {
  final int id;
  final String name;
  ProvinceAndCity.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'];
}
