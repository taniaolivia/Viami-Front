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
      String sex,
      String? fcmToken) async {
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
              "connected": "0",
              "profileImage": "",
              "fcmToken": fcmToken
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
        "connected": "",
        "profileImage": "",
        "verifyEmailToken": null,
        "emailVerified": "0",
        "fcmToken": null
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

  Future<User> getUserByFcmToken(String fcmToken, String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/users/userFcmToken/$fcmToken'),
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
        return false;
      }
    } catch (error) {
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

  Future forgetPassword(String email) async {
    final response = await http.post(
        Uri.parse("${dotenv.env['API_URL_2']}/forgetPassword"),
        body: {"email": email});

    if (response.statusCode == 200 ||
        response.statusCode == 500 ||
        response.statusCode == 401) {
      var res = json.decode(response.body);

      return res;
    } else {
      throw Exception("Failed to load user");
    }
  }

  Future<Map<String, dynamic>> setFcmToken(
      String id, String fcmToken, String token) async {
    final response = await http.patch(
        Uri.parse(
            '${dotenv.env['API_URL']}/users/$id/fcmToken?fcmToken=$fcmToken'),
        headers: <String, String>{
          "Content-Type": "application/json",
          'Authorization': token
        });

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      return res;
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<Map<String, dynamic>> updateUserPlanById(
      String id, String plan, String token) async {
    final response = await http.patch(
        Uri.parse('${dotenv.env['API_URL']}/users/$id/plan'),
        headers: <String, String>{
          "Content-Type": "application/json",
          'Authorization': token
        },
        body: jsonEncode(<String, dynamic>{"plan": plan}));

    if (response.statusCode == 201) {
      var res = json.decode(response.body);
      return res;
    } else {
      throw Exception('Failed to load user');
    }
  }
}
