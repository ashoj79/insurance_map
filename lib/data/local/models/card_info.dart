import 'package:flutter/material.dart';
import 'package:insurance_map/data/remote/model/bank.dart';

class CardInfo {
  String bankId = '', name = '', logo = '';
  Color color = Colors.grey[100]!;

  updateWithBank(Bank bank) {
    bankId = bank.id;
    name = bank.name;
    color = Color(int.parse(bank.color.replaceAll('#', '0xFF')));
    logo = bank.logo;
  }

  reset() {
    bankId = '';
    name = '';
    logo = '';
    color = Colors.grey[100]!;
  }
}
