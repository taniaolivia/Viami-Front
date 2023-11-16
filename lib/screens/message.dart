import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../components/NavigationBarComponent.dart';

import '../models-api/message/messages.dart';
import '../models-api/user/user.dart';
import '../services/message/message.service.dart';
import '../services/message/messages.service.dart';
import '../services/user/auth.service.dart';

import '../widgets/menu_widget.dart';
import 'package:viami/services/user/user.service.dart';

class MessagesPage extends StatefulWidget {
  final String? userId;
  final String reciverId;
  const MessagesPage({Key? key, this.userId, required this.reciverId})
      : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController _messageController = TextEditingController();

  final storage = const FlutterSecureStorage();

  String? token = "";
  String? userId = "";

  bool? tokenExpired;

  Future<User> getUser() {
    Future<User> getConnectedUser() async {
      token = await storage.read(key: "token");
      userId = await storage.read(key: "userId");

      bool isTokenExpired = AuthService().isTokenExpired(token!);

      tokenExpired = isTokenExpired;

      return UserService().getUserById(userId.toString(), token.toString());
    }

    return getConnectedUser();
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    Future<Messages> getMessagesBetweenUsers() {
      Future<Messages> getMessages() async {
        token = await storage.read(key: "token");
        userId = await storage.read(key: "userId");

        return MessagesService().getMessagesBetweenUsers(
            token.toString(), userId.toString(), widget.reciverId.toString());
      }

      return getMessages();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/home");
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            )),
        backgroundColor: const Color(0xFF0081CF),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: getMessagesBetweenUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Erreur : ${snapshot.error}');
          } else {
            List<dynamic> messages = snapshot.data as List<dynamic>;
            return ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                // Vérifiez si le message est du sender ou de l'autre utilisateur
                bool isSenderMessage = messages[index]['senderId'] == userId;

                // Alignez les messages du sender à droite et ceux de l'autre utilisateur à gauche
                return Align(
                  alignment: isSenderMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: isSenderMessage ? Colors.blue : Colors.green,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(messages[index]['message'],
                            style: TextStyle(color: Colors.white)),
                        SizedBox(height: 8.0),
                        Text(messages[index]['date'],
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Champ de texte pour envoyer un nouveau message
                    TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Entrez votre message...',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        // Utilisez le service pour envoyer le message
                        MessageService().sendMessage(
                            _messageController.text,
                            widget.reciverId,
                            userId.toString(),
                            token.toString());

                        // Efface le champ de message après l'envoi
                        _messageController.clear();
                        Navigator.pop(context); // Ferme le modal bottom sheet
                      },
                      child: Text('Envoyer'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose du socket lorsque le widget est détruit
    MessageService().dispose();
    super.dispose();
  }
}
