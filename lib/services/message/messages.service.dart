import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/messenger/messages.dart';

class MessagesService {
  Future<Messages> getAllMessagesBySender(String token, String userId) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/users/$userId/messages'),
      headers: <String, String>{
        'Authorization': token,
      },
    );
    print(response.body);

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Messages.fromJson(res);
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<Messages> getLastMessageTwoUsers(String token, String userId) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/users/$userId/message'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Messages.fromJson(res);
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<Messages> getSearchedUsers(
      String token, String userId, String search) async {
    final response = await http.get(
      Uri.parse(
          '${dotenv.env['API_URL']}/messages/search/users?search=$search&userId=$userId'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Messages.fromJson(res);
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<Messages> getDiscussionsForMessage(
      String token, String messageId) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/messages/discussions/$messageId'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      return Messages.fromJson(res);
    } else {
      throw Exception('Failed to load travels');
    }
  }
}
