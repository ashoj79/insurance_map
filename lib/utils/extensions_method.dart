import 'package:flutter/material.dart';

extension StingHelpers on String {
  Widget toLicenseWidget([double textSize = 16]) {
    if (int.tryParse(this) != null) return Text(toPersian(), textAlign: TextAlign.center);

    String part1 = '', part2 = '', part3 = '', part4 = '';
    part1 = this[0] + this[1];
    part2 = length == 10 ? this[2] + this[3] + this[4] : this[2];
    String l = replaceAll(part1 + part2, '');
    part3 = l[0] + l[1] + l[2];
    part4 = l[3] + l[4];

    return Row(
      textDirection: TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(part1.toPersian(), style: TextStyle(fontSize: textSize)),
        const SizedBox(width: 4),
        Text(part2.toPersian(), style: TextStyle(fontSize: textSize)),
        const SizedBox(width: 4),
        Text(part3.toPersian(), style: TextStyle(fontSize: textSize)),
        const SizedBox(width: 4),
        Text(part4.toPersian(), style: TextStyle(fontSize: textSize))
      ],
    );
  }

  String formatCardNumber() {
    String seg1 = '', seg2 = '', seg3 = '', seg4 = '';
    for (var i = 0; i < 4; i++) {
      for (var j = i * 4; j < i * 4 + 4; j++) {
        switch (i) {
          case 0:
            seg1 += this[j];
            break;
          case 1:
            seg2 += this[j];
            break;
          case 2:
            seg3 += this[j];
            break;
          case 3:
            seg4 += this[j];
            break;
        }
      }
    }

    return '$seg1 $seg2 $seg3 $seg4';
  }
  
  String toPersian() {
    return replaceAll('0', '۰').replaceAll('1', '۱').replaceAll('2', '۲').replaceAll('3', '۳').replaceAll('4', '۴').replaceAll('5', '۵').replaceAll('6', '۶').replaceAll('7', '۷')
        .replaceAll('8', '۸')
        .replaceAll('9', '۹');
  }
}