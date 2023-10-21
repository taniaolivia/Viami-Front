import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/userInterest/usersInterests.dart';

class UsersInterestsService {
  Future<UsersInterests> getAllUsersInterests(String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/usersInterests'),
      headers: <String, String>{'Authorization': token},
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return UsersInterests.fromJson(res['data']);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<UsersInterests> getUserInterestsById(
      String userId, String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/users/$userId/interests'),
      headers: <String, String>{'Authorization': token},
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return UsersInterests.fromJson(res);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<UsersInterests> getInterestUsersById(
      String interestId, String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/interests/$interestId/users'),
      headers: <String, String>{'Authorization': token},
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return UsersInterests.fromJson(res);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
