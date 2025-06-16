class Project {
  final String id, title, section, image;

  Project.fromJson(Map<String, dynamic> data)
    : id = data['id'],
      title = data['title'],
      section = data['section'],
      image = data['image_url'];
}