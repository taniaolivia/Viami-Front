import 'package:flutter/material.dart';

import 'menu_item.dart';

class MenuItems {
  static const home = MenuItem('Accueil', Icons.home);
  static const payment = MenuItem('Paiement', Icons.payment);
  static const notification = MenuItem('Notifications', Icons.notifications);
  static const nousContacter = MenuItem("Nous contacter", Icons.email);
  static const mentionLegal = MenuItem('Mentions légales', Icons.balance);
  static const settings = MenuItem('Paramètres', Icons.settings);

  static const all = <MenuItem>[
    home,
    payment,
    notification,
    settings,
    nousContacter,
    mentionLegal
  ];
}
