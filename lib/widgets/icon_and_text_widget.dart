import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class IconAndTextWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? subtext;
  final Color color;
  final Color iconColor;

  const IconAndTextWidget({
    Key? key,
    required this.icon,
    required this.text,
    this.subtext,
    required this.color,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
        ),
        SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              text,
              style: TextStyle(
                  color: Color(0xFF6A778B),
                  fontWeight: FontWeight.normal,
                  fontFamily: "Montserrat"),
              minFontSize: 12,
              maxFontSize: 13,
              textAlign: TextAlign.center,
            ),
            if (subtext != null)
              AutoSizeText(
                subtext!,
                style: TextStyle(
                    color: Color(0xFF0A2753),
                    fontWeight: FontWeight.normal,
                    fontFamily: "Montserrat"),
                minFontSize: 12,
                maxFontSize: 13,
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ],
    );
  }
}
