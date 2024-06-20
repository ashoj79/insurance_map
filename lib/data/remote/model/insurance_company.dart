class InsuranceCompany {
  final String id, name, logo;
  InsuranceCompany.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        logo = data['logo_url'];
}
