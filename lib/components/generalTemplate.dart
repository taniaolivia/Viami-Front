import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class GeneralTemplate extends StatefulWidget {
  final String image;
  final Widget content;
  final double containerHeight;
  final double contentHeight;
  final String? title;

  const GeneralTemplate(
      {Key? key,
      required this.image,
      required this.content,
      required this.containerHeight,
      required this.contentHeight,
      this.title})
      : super(key: key);

  @override
  State<GeneralTemplate> createState() => _GeneralTemplateState();
}

class _GeneralTemplateState extends State<GeneralTemplate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
              top: 0,
              child: Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.fromLTRB(
                      0,
                      MediaQuery.of(context).size.width / 5,
                      0,
                      MediaQuery.of(context).size.width / 5),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: const Color(0xFF0081CF),
                      image: DecorationImage(
                          image: NetworkImage(widget.image),
                          fit: BoxFit.cover,
                          repeat: ImageRepeat.noRepeat)),
                  child: AutoSizeText(
                    widget.title!.toUpperCase(),
                    minFontSize: 23,
                    maxFontSize: 25,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 20.0,
                            spreadRadius: 5.0,
                            offset: Offset(
                              0.0,
                              0.0,
                            ),
                          )
                        ]),
                  ))),
          Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                height:
                    MediaQuery.of(context).size.height / widget.containerHeight,
                decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    border: Border.all(
                      width: 2,
                      color: const Color(0xFFFFFFFF),
                    ),
                    borderRadius: BorderRadius.circular(30)),
              )),
          Positioned(
              top: MediaQuery.of(context).size.height / widget.contentHeight,
              height: MediaQuery.of(context).size.height,
              left: MediaQuery.of(context).size.width / 13,
              right: MediaQuery.of(context).size.width / 13,
              child: widget.content),
        ],
      ),
    );
  }
}
