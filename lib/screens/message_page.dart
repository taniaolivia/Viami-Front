import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../components/NavigationBarComponent.dart';
import '../widgets/menu_widget.dart';

class MessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Text(
        "message",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
