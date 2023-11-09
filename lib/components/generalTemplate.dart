import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class GeneralTemplate extends StatefulWidget {
  final String image;
  final Widget content;
  final double imageHeight;
  final double containerHeight;
  final double contentHeight;
  final String? title;
  final String? redirect;

  const GeneralTemplate(
      {Key? key,
      required this.image,
      required this.imageHeight,
      required this.content,
      required this.containerHeight,
      required this.contentHeight,
      this.title,
      this.redirect})
      : super(key: key);

  @override
  State<GeneralTemplate> createState() => _GeneralTemplateState();
}

class _GeneralTemplateState extends State<GeneralTemplate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Positioned(
              top: 0,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height:
                      MediaQuery.of(context).size.height / widget.imageHeight,
                  decoration: BoxDecoration(
                      color: const Color(0xFF0081CF),
                      image: DecorationImage(
                          image: NetworkImage(widget.image),
                          fit: BoxFit.cover,
                          repeat: ImageRepeat.noRepeat)),
                  child: Column(children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            width: 40,
                            height: 40,
                            margin: MediaQuery.of(context).size.width <= 320
                                ? const EdgeInsets.fromLTRB(20, 20, 0, 0)
                                : const EdgeInsets.fromLTRB(20, 40, 0, 0),
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: IconButton(
                                onPressed: () {
                                  widget.redirect != null
                                      ? Navigator.pushNamed(
                                          context, widget.redirect!)
                                      : Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Color.fromRGBO(0, 0, 0, 0.4),
                                  size: 20,
                                )))),
                    AutoSizeText(
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
                    ),
                  ]))),
          Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                height:
                    MediaQuery.of(context).size.height / widget.containerHeight,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 2,
                      color: Colors.white,
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
