import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/message/messages.dart';
import 'package:http/http.dart' as http;

class MessagesService {
  Future<Messages> getMessagesBetweenUsers(
      String token, String senderId, String responderId) async {
    final response = await http.get(
      Uri.parse(
          '${dotenv.env['API_URL']}/users/:senderId/:responderId/messages'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Messages.fromJson(res);
    } else {
      throw Exception('Failed to load activities');
    }
  }
}
