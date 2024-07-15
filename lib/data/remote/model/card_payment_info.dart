import 'package:insurance_map/data/local/temp_db.dart';

class CardPaymentInfo {
  final String link;
  final int amount;

  CardPaymentInfo.fromJson(Map<String, dynamic> data)
      : link = data['payment_url'],
        amount = data['amount'];

  String getMessage() {
    String msg = TempDB.getMessage('in-app-text-bank-cart-payment-alert');
    return msg.replaceFirst(':amount', amount.toString());
  }
}
