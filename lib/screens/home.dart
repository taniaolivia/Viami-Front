import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFFAFAFA),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/location.png', // Chemin vers l'image dans le répertoire assets
                width: 20.0, // Ajustez la largeur de l'image selon vos besoins
                height: 20.0, // Ajustez la hauteur de l'image selon vos besoins
                color: Color(0xFF0081CF), // Couleur de l'image
              ),
              SizedBox(
                  width: 8.0), // Ajoute un espace entre l'image et le texte
              Text(
                "Paris",
                style: TextStyle(color: Color(0xFF000000)),
              ),
            ],
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Color(0xFF6D7D95),
            size: 27.0,
          ),
          onPressed: () {},
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
                right: 16.0), // Ajustez la valeur selon vos besoins
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/logo.png'),
              radius: 16, // Ajustez le rayon selon vos besoins
            ),
          )
        ],
      ),
    );
  }
}
