import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../widgets/menu_widget.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
                color: const Color(0xFF0081CF),
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
              child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/profile");
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        '${dotenv.env['CDN_URL']}/assets/profil.png'),
                    radius: 16,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
