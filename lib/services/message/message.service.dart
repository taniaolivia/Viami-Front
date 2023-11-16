import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;

class MessageService {
// Connecte le socket à l'URL du serveur Socket.IO
  late io.Socket socket;
  MessageService() {
    // Déplacez l'initialisation du socket dans le constructeur
    socket = io.io('${dotenv.env['SOCKET_URL']}', <String, dynamic>{
      'transports': ['websocket'],
    });

    // Connecte le socket au serveur Socket.IO
    socket.connect();
  }

  Future<void> sendMessage(
      String message, String responderId, String senderId, String token) async {
    final Map<String, dynamic> requestBody = {
      'message': message,
      'senderId': senderId,
      'responderId': responderId,
    };
    final response =
        await http.post(Uri.parse('${dotenv.env['API_URL']}/sendMessage'),
            headers: <String, String>{
              "Content-Type": "application/json",
              'Authorization': token,
            },
            body: jsonEncode(requestBody));

    if (response.statusCode == 200) {
      socket.emit('chat message', requestBody);
    } else {
      throw Exception('Failed to load user');
    }
  }

  void dispose() {
    // Dispose du socket lorsque vous avez fini de l'utiliser
    socket.disconnect();
  }
}
