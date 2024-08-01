import 'package:flutter/material.dart';

extension StingHelpers on String {
  Widget toLicenseWidget([double textSize = 16]) {
    if (int.tryParse(this) != null) return Text(this);

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
        Text(part1, style: TextStyle(fontSize: textSize)),
        const SizedBox(width: 4),
        Text(part2, style: TextStyle(fontSize: textSize)),
        const SizedBox(width: 4),
        Text(part3, style: TextStyle(fontSize: textSize)),
        const SizedBox(width: 4),
        Text(part4, style: TextStyle(fontSize: textSize))
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
}