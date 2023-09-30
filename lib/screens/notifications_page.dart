import 'package:flutter/material.dart';

import '../widgets/menu_widget.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: MenuWidget(),
        elevation: 0,
        backgroundColor: Color(0xFFFAFAFA),
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
              SizedBox(width: 8.0),
              Text(
                "Paris",
                style: TextStyle(color: Color(0xFF000000)),
              ),
            ],
          ),
        ),
        iconTheme: IconThemeData(color: Color(0xFF6D7D95)),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: 16.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(0xFFFFFFFF),
                  width: 2.0,
                ),
              ),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/profil.png'),
                radius: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}
