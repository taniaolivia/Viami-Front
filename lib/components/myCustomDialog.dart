import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:viami/services/message/groups.service.dart';
import '../models-api/user/users.dart';
import '../models-api/userImage/usersImages.dart';
import '../services/user/users.service.dart';
import '../services/userImage/usersImages.service.dart';

class MyCustomDialog extends StatefulWidget {
  final int? groupId;
  const MyCustomDialog({Key? key, this.groupId}) : super(key: key);

  @override
  State<MyCustomDialog> createState() => _MyCustomDialogState();
}

class _MyCustomDialogState extends State<MyCustomDialog> {
  final _formKeySearchNameUser = GlobalKey<FormState>();
  TextEditingController searchControllerNameUser = TextEditingController();
  final storage = const FlutterSecureStorage();
  String? token = "";
  Users? allUsers;
  String? userId = "";

  Future<void> getAll() async {
    token = await storage.read(key: "token");
    userId = await storage.read(key: "userId");
    allUsers = await UsersService()
        .getUsersWithConversation(token.toString(), userId!);

    if (mounted) {
      setState(() {});
    }
  }

  Future<UsersImages> getUserImages(String userId) async {
    token = await storage.read(key: "token");

    final images = await UsersImagesService().getUserImagesById(
      userId,
      token.toString(),
    );

    return images;
  }

  void search(Users users) {
    setState(() {
      allUsers = users;
    });
  }

  @override
  void initState() {
    super.initState();
    getAll();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      title: const Text(
        'Sélectionnez un voyageur',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            // Barre de recherche
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2.2,
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
                            contentPadding: EdgeInsets.fromLTRB(15, 5, 10, 5),
                            labelText: 'Prénom',
                            hintText: '',
                            labelStyle: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0081CF),
                    padding: const EdgeInsets.only(top: 14, bottom: 14),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 20.0,
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
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () async {
                  var clearName = await UsersService()
                      .getUsersWithConversation(token.toString(), userId!);

                  setState(() {
                    allUsers = clearName;
                    searchControllerNameUser.text = "";
                  });

                  FocusScope.of(context).unfocus();
                },
                child: const Text(
                  "Réinitialiser",
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ),
            ),
            if (allUsers?.users.isEmpty ?? true)
              const Text('Aucun utilisateur trouvé'),
            if (!(allUsers?.users.isEmpty ?? true))
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(allUsers?.users.length ?? 0, (index) {
                  var user = allUsers?.users[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          FutureBuilder<UsersImages>(
                            future: getUserImages(user!.id ?? ""),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container();
                              } else if (snapshot.hasError) {
                                return const Text(
                                  '',
                                  textAlign: TextAlign.center,
                                );
                              } else if (!snapshot.hasData) {
                                return const Text('');
                              }

                              var image = snapshot.data!;
                              var avatar = image.userImages.length != 0
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          image.userImages[0].image),
                                      maxRadius: 20,
                                    )
                                  : CircleAvatar(
                                      backgroundColor: const Color.fromARGB(
                                          255, 220, 234, 250),
                                      foregroundImage: NetworkImage(
                                          "${dotenv.env['CDN_URL']}/assets/noprofile.png"),
                                      maxRadius: 20,
                                    );

                              return avatar;
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(
                              '${toBeginningOfSentenceCase(user.firstName)} ${toBeginningOfSentenceCase(user.lastName)}')
                        ]),
                        IconButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                            Colors.blue,
                          )),
                          onPressed: () async {
                            try {
                              var result = await GroupsService().addUserToGroup(
                                  token.toString(),
                                  user.id,
                                  widget.groupId.toString());
                              var message = result.toString();

                              // Show success dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    surfaceTintColor: Colors.white,
                                    content: Text(message),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).popAndPushNamed(
                                              '/messages'); // Refresh the page
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } catch (e) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    surfaceTintColor: Colors.white,
                                    title: const Text('Erreur'),
                                    content: Text(e.toString()),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("D'accord"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.add,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }
}
