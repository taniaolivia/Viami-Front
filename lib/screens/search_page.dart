import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../components/NavigationBarComponent.dart';
import '../widgets/menu_widget.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Text(
        "SearchPage",
        style: TextStyle(color: Colors.black12),
      ),
    );
  }
}
