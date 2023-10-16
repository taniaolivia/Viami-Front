import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  bool startAnimation = false;
  final List<String> items = [
    "Supprimer le compte ",
    "item 2 ",
    "item3",
    "item 2 ",
    "item 2 ",
    "item 2 ",
    "item 2 ",
    "item 2 ",
    "item 2 ",
    "item 2 ",
    "item 2 ",
    "item 2 ",
    "item 2 ",
  ];
  final List<IconData> icons = [
    Icons.delete,
    Icons.delete,
    Icons.delete,
    Icons.delete,
    Icons.delete,
    Icons.delete,
    Icons.delete,
    Icons.delete,
    Icons.delete,
    Icons.delete,
    Icons.delete,
    Icons.delete,
    Icons.delete,
  ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        startAnimation = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/home');

                            //Navigator.pop(context);
                          },
                          child: Padding(
                              padding: EdgeInsets.only(top: 30, left: 20),
                              child: Image.asset("assets/return.png"))),
                      const SizedBox(
                        width: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 60),
                        child: Text(
                          "Paramètres",
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      )
                    ],
                  )
                ],
              )),
          const SizedBox(
            height: 15,
          ),
          ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return item(index);
            },
          ),
        ]),
      )),
    );
  }

  Widget item(int index) {
    return GestureDetector(
        onTap: () {
          if (index == 0) {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      actions: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Non')),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            onPressed: () {
                              // Write code to delete item
                            },
                            child: const Text(
                              'Oui',
                            )),
                      ],
                      title: Text("Suppression du compte"),
                      content: Text(
                          "Êtes-vous sûr de vouloir supprimer votre compte ?"),
                    ));
            //Navigator.pushNamed(context, '/home');

            //Navigator.pop(context);

            //Navigator.pushNamed(context, '/home');
          }
        },
        child: AnimatedContainer(
            height: 65,
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 300 + (index * 100)),
            transform: Matrix4.translationValues(
                startAnimation ? 0 : MediaQuery.of(context).size.width, 0, 0),
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 40,
            ),
            decoration: BoxDecoration(
              color: Color.fromARGB(137, 248, 244, 244),
              borderRadius: BorderRadius.circular(10),
              //border: Border.all(color: Color.fromARGB(255, 9, 10, 10)
            ),
            child: Card(
                child: ListTile(
              title: Text(
                " ${items[index]}",
                style: TextStyle(fontSize: 16),
              ),
              trailing: Icon(icons[index]),
            ))));
  }
}
