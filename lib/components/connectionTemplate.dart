import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ConnectionTemplate extends StatefulWidget {
  final Widget form;
  final String title;
  final String subtitle;
  final Widget button;
  final String optionText;
  final String optionAction;
  final String redirectText;

  const ConnectionTemplate(
      {Key? key,
      required this.form,
      required this.title,
      required this.subtitle,
      required this.button,
      required this.optionText,
      required this.optionAction,
      required this.redirectText})
      : super(key: key);

  @override
  State<ConnectionTemplate> createState() => _ConnectionTemplateState();
}

class _ConnectionTemplateState extends State<ConnectionTemplate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: const Color(0xFFFFFFFF),
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
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
                          padding: const EdgeInsets.fromLTRB(10, 60, 0, 0),
                          child: Image.asset(
                            "assets/logo.png",
                            width: MediaQuery.of(context).size.width / 2.2,
                          )),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height < 600
                            ? 10.0
                            : 20.0),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: AutoSizeText(
                            widget.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            minFontSize: 18,
                            maxFontSize: 20,
                            textAlign: TextAlign.left,
                          )),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(
                              20,
                              MediaQuery.of(context).size.height < 600
                                  ? 10.0
                                  : 20.0,
                              0,
                              0),
                          child: AutoSizeText(
                            widget.subtitle,
                            minFontSize: 9,
                            maxFontSize: 13,
                            textAlign: TextAlign.left,
                            style: const TextStyle(color: Colors.white),
                          )),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height < 600
                            ? 30.0
                            : 40.0),
                  ])),
              widget.form,
              widget.button,
              const SizedBox(height: 20),
              const AutoSizeText("OU",
                  minFontSize: 11,
                  maxFontSize: 13,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AutoSizeText(widget.optionText,
                      minFontSize: 11,
                      maxFontSize: 13,
                      style: const TextStyle()),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, widget.optionAction);
                      },
                      child: AutoSizeText(widget.redirectText,
                          minFontSize: 11,
                          maxFontSize: 13,
                          style: const TextStyle(
                              decoration: TextDecoration.underline))),
                ],
              ),
              const SizedBox(height: 20),
            ]))));
  }
}
