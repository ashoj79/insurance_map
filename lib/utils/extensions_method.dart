import 'package:flutter/material.dart';

extension StingHelpers on String {
  Widget toLicenseWidget() {
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
        Text(part1),
        const SizedBox(width: 4),
        Text(part2),
        const SizedBox(width: 4),
        Text(part3),
        const SizedBox(width: 4),
        Text(part4)
      ],
    );
  }
}