import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/userLanguage/usersLanguages.dart';

class UsersLanguagesService {
  Future<UsersLanguages> getAllUsersLanguages(String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/usersLanguages'),
      headers: <String, String>{'Authorization': token},
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return UsersLanguages.fromJson(res['data']);
    } else {
      throw Exception('Failed to load user languages');
    }
  }

  Future<UsersLanguages> getUserLanguagesById(
      String userId, String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/users/$userId/languages'),
      headers: <String, String>{'Authorization': token},
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return UsersLanguages.fromJson(res);
    } else {
      throw Exception('Failed to load user languages');
    }
  }

  Future<UsersLanguages> getLanguageUsersById(
      String languageId, String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/languages/$languageId/users'),
      headers: <String, String>{'Authorization': token},
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return UsersLanguages.fromJson(res);
    } else {
      throw Exception('Failed to load user langauges');
    }
  }
}
