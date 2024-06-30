class Category {
  final String id, title, logo;

  Category.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        logo = data['logo_url'];
}
