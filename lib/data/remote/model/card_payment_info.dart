class CardPaymentInfo {
  final String link, message;
  final int amount;

  CardPaymentInfo.fromJson(Map<String, dynamic> data)
      : link = data['payment_url'],
        amount = data['amount'],
        message = data['message'] ?? '';
}
