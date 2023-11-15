import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../components/NavigationBarComponent.dart';
import '../widgets/menu_widget.dart';

class MessagesPage extends StatefulWidget {
  final String? userId;
  const MessagesPage({Key? key, this.userId}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/home");
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            )),
        backgroundColor: const Color(0xFF0081CF),
      ),
      backgroundColor: Colors.white,
      body: Text(
        'ok',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
