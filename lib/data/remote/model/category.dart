class Category {
  final String id, title, logo;
  final bool isHaveChild;

  Category.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        logo = data['logo_url'],
        isHaveChild = data['children_count'] > 0;
}
