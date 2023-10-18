import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../models/menu_items.dart';

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
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFFFFFFF),
                            width: 3.0,
                          ),
                        ),
                        child: const CircleAvatar(
                          backgroundImage: AssetImage('assets/profil.png'),
                          radius: 50.0,
                        ),
                      ),
                    ),
                    const SizedBox(
                        height:
                            10.0), // Add some space between CircleAvatar and Text
                    const Padding(
                      padding: EdgeInsets.only(left: 17.0),
                      child: Text(
                        "Your Name", // Replace with the actual name
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19.0,
                        ),
                      ),
                    ),
                    const Spacer(),
                    ...MenuItems.all.map(buildMenuItem).toList(),
                    const Spacer(flex: 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          Navigator.pushNamed(context, '/home');
                        },
                        icon: const Icon(Icons.logout,
                            color: Colors.white), // Set icon color
                        label: const Text(
                          "Logout",
                          style:
                              TextStyle(color: Colors.white), // Set text color
                        ),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          side: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    const Spacer(),
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
