import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:viami/models/introduction_item.dart';

class LiquidSwipeAnimation extends StatefulWidget {
  final int page;
  final List<IntroductionItem> data;
  final Widget redirect;

  const LiquidSwipeAnimation(
      {Key? key,
      required this.page,
      required this.data,
      required this.redirect})
      : super(key: key);

  @override
  State<LiquidSwipeAnimation> createState() => _LiquidSwipeAnimationState();
}

class _LiquidSwipeAnimationState extends State<LiquidSwipeAnimation> {
  int page = 0;
  late LiquidController liquidController;

  @override
  void initState() {
    liquidController = LiquidController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          LiquidSwipe.builder(
            initialPage: 0,
            itemCount: widget.data.length,
            itemBuilder: (context, index) {
              return Container(
                  width: double.infinity,
                  color: widget.data[index].color,
                  child: Column(
                    children: <Widget>[
                      ClipRRect(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(80),
                              bottomRight: Radius.circular(80)),
                          child: widget.data[index].image != ""
                              ? Image.network(
                                  widget.data[index].image!,
                                  height:
                                      MediaQuery.of(context).size.height / 1.7,
                                )
                              : Container()),
                      Container(
                          padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 3.8,
                          decoration: BoxDecoration(
                              color: widget.data[index].color,
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AutoSizeText(
                                  widget.data[index].text1!.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  minFontSize: 20,
                                  maxFontSize: 25,
                                ),
                                const SizedBox(height: 20),
                                AutoSizeText(
                                  widget.data[index].text2!.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  minFontSize: 10,
                                  maxFontSize: 15,
                                  style: const TextStyle(color: Colors.white),
                                )
                              ]))
                    ],
                  ));
            },
            positionSlideIcon: 0.8,
            slideIconWidget:
                const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPageChangeCallback: pageChangeCallback,
            waveType: WaveType.liquidReveal,
            liquidController: liquidController,
            fullTransitionValue: 880,
            enableSideReveal: true,
            preferDragFromRevealedArea: true,
            enableLoop: false,
            ignoreUserGestureWhileAnimating: true,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextButton(
                onPressed: () {
                  if (liquidController.currentPage < widget.data.length - 2) {
                    liquidController.jumpToPage(
                        page: liquidController.currentPage + 1);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => widget.redirect),
                    );
                  }
                },
                style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.01),
                    foregroundColor: Colors.black),
                child: const AutoSizeText(
                  "Suivant",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                  minFontSize: 9,
                  maxFontSize: 12,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  pageChangeCallback(int lpage) {
    if (page < widget.data.length - 2) {
      setState(() {
        page = lpage;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => widget.redirect),
      );
    }
  }
}
