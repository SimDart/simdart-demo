import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  const ResultCard(
      {super.key,
      required this.icon,
      required this.value,
      required this.text,
      this.textColor = Colors.black});

  final IconData icon;
  final Color textColor;
  final String value;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 160,
        height: 120,
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!)),
            padding: EdgeInsets.all(12),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  // Espaço entre ícone e texto
                  Text(value, style: TextStyle(fontSize: 34, color: textColor)),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(icon, color: textColor, size: 18),
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: SizedBox(
                              width: 8.0), // Espaço entre ícone e texto
                        ),
                        TextSpan(
                          text: text,
                          style: TextStyle(fontSize: 14, color: textColor),
                        ),
                      ],
                    ),
                  )
                ])));
  }
}
