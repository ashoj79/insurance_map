import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String text, [Function? onClick, String buttonText = 'تائید']) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
        ),
        if(onClick != null)
          TextButton(onPressed: () => onClick(), child: Text(buttonText, style: const TextStyle(color:  Color.fromARGB(255, 128, 91, 255)),))
      ],
    )
  ));
}
