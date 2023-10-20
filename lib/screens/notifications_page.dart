import 'package:flutter/material.dart';

import '../widgets/menu_widget.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        leading: MenuWidget(),
        elevation: 0,
        backgroundColor: const Color(0xFFFAFAFA),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/location.png',
                width: 20.0,
                height: 20.0,
                color: Color(0xFF0081CF),
              ),
              const SizedBox(width: 8.0),
              const Text(
                "Paris",
                style: TextStyle(color: Color(0xFF000000)),
              ),
            ],
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF6D7D95)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 16.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFFFFFFF),
                  width: 2.0,
                ),
              ),
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/profil.png'),
                radius: 16,
              ),
            ),
          )
        ],
      ),
      body: const Text(
        "NotificationsPage",
        style: TextStyle(color: Colors.black12),
      ),
    );
  }
}
