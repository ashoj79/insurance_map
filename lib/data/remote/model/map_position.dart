class MapPositionData {
  final MapPositionType type;
  final String id, name, address, officePhone, mobile, insurance, shopName;
  final double lat, lng;

  MapPositionData.insurance(Map<String, dynamic> data)
      : type = MapPositionType.Insurance,
        id = data['id'],
        name = data['user'] != null ? data['user']['name'] ?? '' : '',
        address = data['address'] ?? '',
        officePhone = data['phone_number'] ?? '',
        mobile = '',
        insurance = data['insurance_company']['name'] ?? '',
        shopName = '',
        lat = double.parse(data['latitude']),
        lng = double.parse(data['longitude']);

  MapPositionData.vendor(Map<String, dynamic> data)
      : type = MapPositionType.Vendor,
        id = data['id'],
        name = data['user'] != null ? data['user']['name'] ?? '' : '',
        address = data['address'] ?? '',
        officePhone = data['phone_number'] ?? '',
        mobile = '',
        insurance = '',
        shopName = data['shop_name'] ?? '',
        lat = double.parse(data['latitude']),
        lng = double.parse(data['longitude']);

  Map<String, String> getData() {
    if (type == MapPositionType.Insurance) {
      return {
        'نام و نام خانوادگی': name,
        'موبایل': mobile,
        'تلفن دفتر‌': officePhone,
        'آدرس': address,
        'بیمه': insurance
      };
    } else {
      return {
        'نام و نام خانوادگی': name,
        'نام فروشگاه': shopName,
        'آدرس': address,
      };
    }
  }
}

enum MapPositionType {
   Vendor, Insurance
}