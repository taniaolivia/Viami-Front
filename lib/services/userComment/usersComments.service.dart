import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/userComment/usersComments.dart';

class UsersCommentsService {
  Future<UsersComments> getAllUsersComments(String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/usersComments'),
      headers: <String, String>{'Authorization': token},
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return UsersComments.fromJson(res['data']);
    } else {
      throw Exception('Failed to load user comments');
    }
  }

  Future<UsersComments> getUserCommentsById(String userId, String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/users/$userId/comments'),
      headers: <String, String>{'Authorization': token},
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return UsersComments.fromJson(res);
    } else {
      throw Exception('Failed to load user comments');
    }
  }
}
