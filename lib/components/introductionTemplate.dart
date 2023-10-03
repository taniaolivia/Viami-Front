import 'package:flutter/material.dart';

class IntroductionTemplate extends StatefulWidget {
  final String image;
  final Widget content;
  final double containerHeight;
  final double imageHeight;

  const IntroductionTemplate({
    Key? key,
    required this.image,
    required this.content,
    required this.containerHeight,
    required this.imageHeight
  }) : super(key: key);

  @override
  State<IntroductionTemplate> createState() =>
      _IntroductionTemplateState();
}

class _IntroductionTemplateState extends State<IntroductionTemplate> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
            children: <Widget> [
              Positioned(
                top: 0,
                child: Image.asset(
                    height: MediaQuery.of(context).size.height / widget.imageHeight,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitWidth,
                    widget.image)),
              Positioned(
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / widget.containerHeight,
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      border: Border.all(
                        width: 2,
                        color: const Color(0xFFFFFFFF),
                      ),
                      borderRadius: BorderRadius.circular(20)),
                  child: widget.content
                ))
          ],
        ),
      
    );
  }
}