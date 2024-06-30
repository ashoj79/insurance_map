class SliderModel{
  final String title, logo;

  SliderModel.fromJson(Map<String, dynamic> data)
    : title = data['title'],
      logo = data['logo_url'];
}