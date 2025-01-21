import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  const ResultCard(
      {super.key,
      required this.value,
      required this.text,
      this.textColor = Colors.black});

  final Color textColor;
  final String value;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 200,
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!)),
            padding: EdgeInsets.all(8),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(value, style: TextStyle(fontSize: 28, color: textColor)),
                  Text(text,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: textColor))
                ])));
  }
}
