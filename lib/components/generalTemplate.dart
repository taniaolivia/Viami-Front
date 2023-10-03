import 'package:flutter/material.dart';

class GeneralTemplate extends StatefulWidget {
  final String image;
  final Widget content;
  final double containerHeight;
  final double imageHeight;

  const GeneralTemplate({
    Key? key,
    required this.image,
    required this.content,
    required this.containerHeight,
    required this.imageHeight
  }) : super(key: key);

  @override
  State<GeneralTemplate> createState() =>
      _GeneralTemplateState();
}

class _GeneralTemplateState extends State<GeneralTemplate> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
            children: <Widget> [
              Positioned(
                top: 0,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / widget.imageHeight,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0081CF)
                    ),
                    child: widget.image != "" ? Image.asset(
                        fit: BoxFit.fitWidth,
                        widget.image
                      ) : const SizedBox(height: 20)
                    )
                  ),
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
                )),
              Positioned(
                top: MediaQuery.of(context).size.height / 2.5,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width / 1.1,
                  height: MediaQuery.of(context).size.height / widget.containerHeight,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(
                        width: 2,
                        color:  Colors.blue,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: widget.content
                )),
          ],
        ),
      
    );
  }
}