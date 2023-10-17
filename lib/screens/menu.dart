import 'package:flutter/material.dart';

import '../services/user.service.dart';

class MenuItems {
  static const home = MenuItem('Home', Icons.home);
  static const payment = MenuItem('Payment', Icons.payment);
  static const notification = MenuItem('Notifications', Icons.notifications);
  static const friends = MenuItem('Invite Friends', Icons.card_giftcard);
  static const settings = MenuItem('Settings', Icons.settings);
  //static const logout = MenuItem('Logout', Icons.logout);

  static const all = <MenuItem>[
    home,
    payment,
    notification,
    friends,
    settings,
  ];
}

class MenuPage extends StatelessWidget {
  final MenuItem cuurentItem;
  final ValueChanged<MenuItem> onSelectedItem;

  const MenuPage(
      {Key? key, required this.cuurentItem, required this.onSelectedItem});
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData.dark(),
        child: Scaffold(
          body: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(
                  'assets/drawerHeader.png', // Remplacez ceci par l'URL de votre image
                  fit: BoxFit.cover,
                ),
              ),

              // Menu Content
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFFFFFFFF),
                            width: 3.0,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundImage: AssetImage('assets/profil.png'),
                          radius: 50.0,
                        ),
                      ),
                    ),
                    SizedBox(
                        height:
                            10.0), // Add some space between CircleAvatar and Text
                    Padding(
                      padding: EdgeInsets.only(left: 17.0),
                      child: Text(
                        "Your Name", // Replace with the actual name
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19.0,
                        ),
                      ),
                    ),
                    Spacer(),
                    ...MenuItems.all.map(buildMenuItem).toList(),
                    Spacer(flex: 2),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          String userId =
                              'bc5d440d-afc7-46fc-b724-bddfc18d724c'; // Obtenez l'ID de l'utilisateur
                          bool logoutSuccess = await logout(
                              userId); // Passez l'ID à la fonction logout
                          if (logoutSuccess) {
                            Navigator.pushReplacementNamed(
                                context, '/register');
                          } else {
                            print('Logout failed');
                          }
                        }, //bc5d440d-afc7-46fc-b724-bddfc18d724c
                        icon: Icon(Icons.logout,
                            color: Colors.white), // Set icon color
                        label: Text(
                          "Logout",
                          style:
                              TextStyle(color: Colors.white), // Set text color
                        ),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          side: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildMenuItem(MenuItem item) => ListTile(
        selectedTileColor: Colors.white,
        selected: cuurentItem == item,
        minLeadingWidth: 20,
        leading: Icon(item.icon),
        title: Text(item.title),
        onTap: () => onSelectedItem(item),
      );
}

class MenuItem {
  final String title;
  final IconData icon;

  const MenuItem(this.title, this.icon);
}
