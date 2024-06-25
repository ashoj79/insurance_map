class UserInfo {
  final int bankCartCount, vehicleCount, vendorCount, insuranceOfficeCount;
  UserInfo.fromJson(Map<String, dynamic> data)
      : bankCartCount = data['bank_card_counts'] ?? 0,
        vehicleCount = data['vehicle_counts'] ?? 0,
        vendorCount = data['vendor_counts'] ?? 0,
        insuranceOfficeCount = data['insurance_office_counts'] ?? 0;
}
