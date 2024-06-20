class ShopCategory {
  final String id, title, slug, parentId;
  final List<ShopCategory> children;
  ShopCategory.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        slug = data['slug'],
        parentId = data['parent_id'] ?? '',
        children = data['children'] == null ? [] : List.generate(data['children'].length,
            (index) => ShopCategory.fromJson(data['children'][index]));
}
