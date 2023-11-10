import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import '../components/activity_card.dart';
import '../models/activity.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String? text;

  const ExpandableTextWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  State<ExpandableTextWidget> createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  late String firstHalf;
  late String secondHalf;
  bool hiddenText = true;
  late double textHeight;

  @override
  void initState() {
    // Ne faites pas référence à context ici dans initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    textHeight = MediaQuery.of(context).size.height / 5.63;

    if (widget.text != null && widget.text!.length > textHeight) {
      firstHalf = widget.text!.substring(0, textHeight.toInt());
      secondHalf =
          widget.text!.substring(textHeight.toInt() + 1, widget.text!.length);
    } else {
      firstHalf = widget.text ?? '';
      secondHalf = '';
    }
    return Container(
      child: secondHalf.isEmpty
          ? Text(firstHalf)
          : Column(
              children: [
                Text(hiddenText ? "$firstHalf...." : firstHalf + secondHalf),
                InkWell(
                  onTap: () {
                    setState(() {
                      hiddenText = !hiddenText;
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        hiddenText ? "Show more" : "Show less",
                        style: TextStyle(color: Colors.blue),
                      ),
                      Icon(
                        hiddenText
                            ? Icons.arrow_drop_down
                            : Icons.arrow_drop_up,
                        color: Colors.blue,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height:
                      10, // Ajoutez un espacement entre le texte et le Swiper
                ),
              ],
            ),
    );
  }
}
