import 'package:flutter/material.dart';
import 'package:viami/screens/secondPage.dart';

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
                  right: 16.0), // Ajustez la valeur selon vos besoins
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFFFFFFFF), // Couleur de la bordure
                    width: 2.0, // Largeur de la bordure
                  ),
                ),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/profil.png'),
                  radius: 16, // Ajustez le rayon selon vos besoins
                ),
              ))
        ],
      ),
      drawer: Drawer(
          child: Container(
        color: Colors.white,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Votre nom"),
              accountEmail: Text(""),
              currentAccountPicture: Padding(
                  padding: EdgeInsets.only(
                      right: 16.0), // Ajustez la valeur selon vos besoins
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xFFFFFFFF), // Couleur de la bordure
                        width: 3.0, // Largeur de la bordure
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/profil.png'),
                      radius: 50.0, // Ajustez le rayon selon vos besoins
                    ),
                  )),
              decoration: BoxDecoration(
                // Définissez votre image de fond ici
                image: DecorationImage(
                  image: AssetImage('assets/drawerHeader.png'),
                  fit: BoxFit.cover, // Ajustez le mode d'ajustement
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text(
                "page1",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SecondPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text(
                "page1",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SecondPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text(
                "page1",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SecondPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.card_giftcard),
              title: Text(
                "page1",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SecondPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                "page1",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SecondPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                "page1",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SecondPage()));
              },
            )
          ],
        ),
      )),
      body: Center(
        child: Text('Contenu de l\'application'),
      ),
    );
  }
}
