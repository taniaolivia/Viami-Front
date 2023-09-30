import 'package:flutter/material.dart';

import '../components/NavigationBarComponent.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFFAFAFA),
        title: Center(
            child: Text("Paris",
                style: const TextStyle(color: Color(0xFF000000)))),
        leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Color(0xff6D7D95),
            ),
            onPressed: () {}),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.person))],
      ),
      bottomNavigationBar: NavigationBarComponent(),
    );
  }
}
