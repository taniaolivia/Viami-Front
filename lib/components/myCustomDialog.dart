import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models-api/user/users.dart';
import '../services/user/users.service.dart';

class MyCustomDialog extends StatefulWidget {
  const MyCustomDialog({Key? key}) : super(key: key);

  @override
  State<MyCustomDialog> createState() => _MyCustomDialogState();
}

class _MyCustomDialogState extends State<MyCustomDialog> {
  final _formKeySearchNameUser = GlobalKey<FormState>();
  TextEditingController searchControllerNameUser = TextEditingController();
  final storage = const FlutterSecureStorage();
  String? token = "";
  Users? allUsers;

  Future<Users> getAll() async {
    token = await storage.read(key: "token");
    final allUsers = await UsersService().getAllUsers(token.toString());
    print("allllllllllllllusers");
    print(allUsers.users);

    return allUsers;
  }

  @override
  void initState() {
    super.initState();
    getAll();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Users>(
      future: getAll(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return AlertDialog(
            title: const Text('Erreur'),
            content: const Text('Erreur lors de la récupération des données'),
          );
        } else {
          Users allUsers = snapshot.data!;
          print("allllllllllllllll");
          print(allUsers);
          print(allUsers.users);
          print(allUsers.users[0].firstName);

          return AlertDialog(
            title: const Text('Sélectionnez un voyageur'),
            content: Column(
              children: [
                // Barre de recherche
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Form(
                        key: _formKeySearchNameUser,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez remplir un prénom';
                                }
                                return null;
                              },
                              controller: searchControllerNameUser,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                contentPadding:
                                    EdgeInsets.fromLTRB(15, 5, 10, 5),
                                labelText: 'Recherche par prénom',
                                hintText: '',
                                labelStyle: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0081CF),
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 25.0,
                      ),
                      onPressed: () async {
                        if (_formKeySearchNameUser.currentState!.validate()) {
                          var searchName = searchControllerNameUser.text;

                          var userSearch = await UsersService()
                              .getAllUsersBySerch(token!, searchName);

                          if (userSearch != null) {
                            setState(() {
                              allUsers = userSearch;
                            });
                          }

                          FocusScope.of(context).unfocus();
                        }
                      },
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () async {
                      var clearName = await getAll();

                      setState(() {
                        allUsers = clearName;
                        searchControllerNameUser.text = "";
                      });

                      FocusScope.of(context).unfocus();
                    },
                    child: const Text(
                      "Réinitialiser",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: allUsers.users.length,
                    itemBuilder: (context, index) {
                      var user = allUsers.users[index];
                      print("userrrrrrrrrr");
                      print(user.firstName ?? "");

                      return ListTile(
                        title: Text(user.firstName ?? ""),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
