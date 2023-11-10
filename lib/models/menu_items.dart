import 'package:flutter/material.dart';

import 'menu_item.dart';

class MenuItems {
  static const home = MenuItem('Accueil', Icons.home);
  static const payment = MenuItem('Paiement', Icons.payment);
  static const notification = MenuItem('Notifications', Icons.notifications);
  //static const friends = MenuItem("Invitation d'ami", Icons.card_giftcard);
  static const settings = MenuItem('Paramètres', Icons.settings);
  //static const logout = MenuItem('Logout', Icons.logout);

  static const all = <MenuItem>[
    home,
    payment,
    notification,
    //friends,
    settings,
  ];
}
