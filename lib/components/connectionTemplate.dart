import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ConnectionTemplate extends StatefulWidget {
  final Widget form;
  final String title;
  final String subtitle;
  final Widget button;
  final Widget option;

  const ConnectionTemplate(
      {Key? key,
      required this.form,
      required this.title,
      required this.subtitle,
      required this.button,
      required this.option})
      : super(key: key);

  @override
  State<ConnectionTemplate> createState() => _ConnectionTemplateState();
}

class _ConnectionTemplateState extends State<ConnectionTemplate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: const Color(0xFFE5F3FF),
                child: Column(
                  children: <Widget>[
                    Container(
                        decoration: const BoxDecoration(
                            color: Color(0xFF0081CF),
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20))),
                        child: Column(children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 40, 0, 0),
                                child: Image.asset(
                                  "assets/logo.png",
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                )),
                          ),
                          const SizedBox(height: 30),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: AutoSizeText(
                                  widget.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  minFontSize: 30,
                                  maxFontSize: 35,
                                  textAlign: TextAlign.left,
                                )),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 0, 0),
                                child: AutoSizeText(
                                  widget.subtitle,
                                  minFontSize: 20,
                                  maxFontSize: 25,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(color: Colors.white),
                                )),
                          ),
                          const SizedBox(height: 50),
                        ])),
                    widget.form,
                    widget.button,
                    const SizedBox(height: 40),
                    const AutoSizeText("OU",
                        minFontSize: 20,
                        maxFontSize: 25,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    widget.option
                  ],
                ))));
  }
}
