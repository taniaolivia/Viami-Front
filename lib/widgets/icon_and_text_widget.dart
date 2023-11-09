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
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFFFFFFF),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
        ),
        SizedBox(width: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: AutoSizeText(
            text,
            style: TextStyle(
              color: Color(0xFF6A778B),
              fontWeight: FontWeight.normal,
              fontFamily: "Poppins",
            ),
            minFontSize: 12,
            maxFontSize: 13,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
