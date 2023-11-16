import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/messenger/message.dart';
import 'package:viami/models-api/messenger/messages.dart';

class MessageService {
  Future<Message> getLastMessageTwoUsers(String token, String senderId, String responderId) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/users/$senderId/$responderId/message'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Message.fromJson(res['messages'][0]);
    } else {
      throw Exception('Failed to load travels');
    }
  }

   Future<void> setMessageRead(String token, int messageId) async {
    final response = await http.patch(
      Uri.parse('${dotenv.env['API_URL']}/messages/$messageId'),
      headers: <String, String>{
        'Authorization': token,
      }
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return res;
    } else {
      throw Exception('Failed to load travels');
    }
  }
}