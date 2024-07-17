class TempDB{
  static final Map<String, String> _messages = {}, _pages = {};

  static saveMessages(List<Map<String, dynamic>> data) {
    for (var d in data) {
      _messages[d['key']] = d['message_title'];
    }
  }

  static getMessage(String key) => _messages[key] ?? '';

  static savePage(String slug, String content) {
    _pages[slug] = content;
  }

  static getPage(String slug) => _pages[slug] ?? '';
}