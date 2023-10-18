import 'package:flutter/material.dart';

import 'menu_item.dart';

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
