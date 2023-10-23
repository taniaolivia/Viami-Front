import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
            "A propos de moi",
            minFontSize: 11,
            maxFontSize: 13,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 10),
        FutureBuilder(
            future: getUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var user = snapshot.data!;

                aboutMeController.text = user.description!;

                return Form(
                    key: _formKey,
                    child: TextFormField(
                        maxLength: 500,
                        controller: aboutMeController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFF4F4F4),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                          labelStyle: TextStyle(fontSize: 12),
                        ),
                        maxLines: null));
              }
              return const Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator());
            }),
        const SizedBox(height: 30),
        InterestComponent(),
        const LanguageComponent(),
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
