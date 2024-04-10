import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class IconAndTextWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? subtext;
  final Color color;
  final Color iconColor;
  final VoidCallback? onTap;

  const IconAndTextWidget({
    Key? key,
    required this.icon,
    required this.text,
    this.subtext,
    required this.color,
    required this.iconColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFFFFF),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Icon(
                icon,
                color: iconColor,
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 171, 171, 172),
                      fontWeight: FontWeight.normal,
                      fontFamily: "Poppins",
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Text(
                  subtext != null ? subtext! : "",
                  style: const TextStyle(
                    color: Color(0xFF0A2753),
                    fontWeight: FontWeight.normal,
                    fontFamily: "Poppins",
                  ),
                  textAlign: TextAlign.left,
                )
              ]),
        ],
      ),
    );
  }
}
