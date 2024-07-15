class TempDB{
  static final Map<String, String> _messages = {};

  static saveMessages(List<Map<String, dynamic>> data) {
    for (var d in data) {
      _messages[d['key']] = d['message_title'];
    }
  }

  static getMessage(String key) => _messages[key] ?? '';
}