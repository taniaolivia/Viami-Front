import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'faqDetails.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 50),
        child: Column(children: [
          const Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                "FAQ",
                minFontSize: 18,
                maxFontSize: 20,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF0A2753)),
              )),
          const SizedBox(height: 10),
          const AutoSizeText(
              "Des interrogations, des questions, des craintes ou des demandes ? Notre FAQ peut vous permettre de répondre à vous besoins",
              minFontSize: 11,
              maxFontSize: 15,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.4),
              )),
          const SizedBox(height: 20),
          Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FaqDetailsPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    minimumSize: const Size(100, 20),
                    backgroundColor: const Color(0xFF0081CF),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        side:
                            BorderSide(color: Color(0xFF0081CF), width: 2.0))),
                child: const AutoSizeText('Voir',
                    maxLines: 1,
                    minFontSize: 11,
                    maxFontSize: 13,
                    style:
                        TextStyle(fontFamily: "Poppins", color: Colors.white)),
              )),
        ]));
  }
}
