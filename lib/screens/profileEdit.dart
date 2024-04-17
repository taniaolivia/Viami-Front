import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:viami/components/interestComponent.dart';
import 'package:viami/components/languageComponent.dart';
import 'package:viami/components/photoList.dart';
import 'package:viami/components/snackBar.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/models-api/userInterest/usersInterests.dart';
import 'package:viami/models-api/userLanguage/usersLanguages.dart';
import 'package:viami/services/user/user.service.dart';

class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  TextEditingController aboutMeController = TextEditingController();

  String? token = "";
  String? userId = "";
  int? userInterestsLength = 0;
  List<UserInterest>? userInterests = [];
  int? userLanguagesLength = 0;
  List<UserLanguage>? userLanguages = [];

  Future<User> getUser() {
    Future<User> getConnectedUser() async {
      token = await storage.read(key: "token");
      userId = await storage.read(key: "userId");

      return UserService().getUserById(userId.toString(), token.toString());
    }

    return getConnectedUser();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 20),
        const Align(
          alignment: Alignment.topLeft,
          child: AutoSizeText(
            "Média",
            minFontSize: 11,
            maxFontSize: 13,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 10),
        const PhotoList(imageNumber: 3),
        const SizedBox(height: 30),
        const Align(
          alignment: Alignment.topLeft,
          child: AutoSizeText(
            "À propos de moi",
            minFontSize: 11,
            maxFontSize: 13,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 10),
        FutureBuilder(
            future: getUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(height: 75);
              }

              if (snapshot.hasError) {
                return const Text(
                  '',
                  textAlign: TextAlign.center,
                );
              }

              if (!snapshot.hasData) {
                return Text('');
              }

              var user = snapshot.data!;

              aboutMeController.text =
                  toBeginningOfSentenceCase(user.description)!;

              return Form(
                  key: _formKey,
                  child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      maxLength: 500,
                      controller: aboutMeController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFF4F4F4),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        floatingLabelStyle:
                            TextStyle(color: Color.fromARGB(255, 81, 81, 81)),
                        contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        labelStyle: TextStyle(fontSize: 12),
                      ),
                      maxLines: null));
            }),
        const SizedBox(height: 30),
        InterestComponent(page: "edit", userId: widget.user.id!),
        LanguageComponent(page: "edit", userId: widget.user.id!),
        const SizedBox(height: 30),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                backgroundColor: Colors.blue,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)))),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                var description = aboutMeController.text;
                token = await storage.read(key: "token");
                userId = await storage.read(key: "userId");

                var user = await UserService().updateUserDescriptionById(
                    userId.toString(), description, token.toString());

                if (user != null) {
                  showSnackbar(
                      context,
                      "Votre profil a été modifié avec succès !",
                      "D'accord",
                      "");

                  Navigator.pushNamed(context, "/home");
                }
              }
            },
            child: const AutoSizeText(
              "Valider",
              minFontSize: 11,
              maxFontSize: 13,
              style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
            ))
      ],
    );
  }
}
