import 'package:insurance_map/data/remote/model/province_city.dart';

class SocialResponsibility {
  final String id, title, description;
  final ProvinceAndCity province, city;
  
  SocialResponsibility.fromJson(Map<String, dynamic> data)
    : id = data['id'],
      title = data['title'],
      description = data['section'],
      province = ProvinceAndCity.fromJson(data['province']),
      city = ProvinceAndCity.fromJson(data['city']);
}