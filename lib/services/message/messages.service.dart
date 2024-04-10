import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/messenger/messages.dart';

class MessagesService {
  Future<Messages> getDiscussionsForMessage(
      String token, String? messageId) async {
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
      throw Exception('Failed to load messages');
    }
  }

  Future<Messages> getDiscussionsForGroup(String token, String? groupId) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/messages/discussions/group/$groupId'),
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

  getAllMessagesByUserId(String token, String? userId) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/users/$userId/messages'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      print(res["data"].length);
      return res["data"].length;
    } else {
      throw Exception('Failed to load messages');
    }
  }
}
