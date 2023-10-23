import 'package:viami/models-api/user/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserService {
  Future<User> register(
      String firstName,
      String lastName,
      String email,
      String passsword,
      String phoneNumber,
      String location,
      String birthday,
      String sex) async {
    final response =
        await http.post(Uri.parse("${dotenv.env['API_URL']}/register"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(<String, dynamic>{
              "firstName": firstName,
              "lastName": lastName,
              "email": email,
              "password": passsword,
              "description": "",
              "location": location,
              "phoneNumber": phoneNumber,
              "birthday": birthday,
              "age": 0,
              "sex": sex,
              "lastConnection": "",
              "connected": "0"
            }));

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return User.fromJson(res['user']);
    } else if (response.statusCode == 401) {
      var res = json.decode(response.body);

      return User.fromJson({
        "firstName": "",
        "lastName": "",
        "email": "",
        "password": "",
        "description": "",
        "location": "",
        "phoneNumber": "",
        "birthday": "",
        "age": 0,
        "sex": "",
        "lastConnection": "",
        "message": res['message'],
        "connected": ""
      });
    } else {
      throw Exception("Failed to load user");
    }
  }

  Future<User> getUserById(String id, String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/users/$id'),
      headers: <String, String>{'Authorization': token},
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return User.fromJson(res['user']);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<Map<String, dynamic>> updateUserDescriptionById(
      String id, String description, String token) async {
    final response = await http.patch(
        Uri.parse('${dotenv.env['API_URL']}/users/$id/description'),
        headers: <String, String>{
          "Content-Type": "application/json",
          'Authorization': token
        },
        body: jsonEncode(<String, dynamic>{"description": description}));

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      return res;
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<bool> deleteUserById(String? id, String token) async {
    final String deleteUserByIdUrl = '${dotenv.env['API_URL']}/users/$id';

    try {
      final response = await http.delete(
        Uri.parse(deleteUserByIdUrl),
        headers: <String, String>{'Authorization': token},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return true;
      } else {
        print('Failed to logout. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error during logout: $error');
      return false;
    }
  }

  Future<bool> updateUserPasswordById(
      String? id, String token, String password) async {
    final String updateUserPasswordByIdUrl =
        '${dotenv.env['API_URL']}/users/$id';

    try {
      final response = await http.patch(Uri.parse(updateUserPasswordByIdUrl),
          headers: <String, String>{
            'Authorization': token,
            "Content-Type": "application/json"
          },
          body: jsonEncode(<String, dynamic>{"password": password}));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }
}