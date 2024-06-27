class Bank {
  final String id, name, color, logo;
  final List<String> prefixs;

  Bank.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        color = data['card_color'],
        logo = data['logo_url'],
        prefixs = data['card_number_prefix'].cast<String>();
}
