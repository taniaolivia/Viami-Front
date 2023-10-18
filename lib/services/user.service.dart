import 'package:viami/models-api/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  Future<User> register(
      String firstName,
      String lastName,
      String email,
      String passsword,
      String phoneNumber,
      String location,
      num age,
      String sex) async {
    final response =
        await http.post(Uri.parse("http://10.0.2.2:3333/user/register"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(<String, dynamic>{
              "firstName": firstName,
              "lastName": lastName,
              "email": email,
              "password": passsword,
              "interest": "",
              "description": "",
              "location": location,
              "phoneNumber": phoneNumber,
              "age": age,
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
        "interest": "",
        "description": "",
        "location": "",
        "phoneNumber": "",
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
      Uri.parse('http://10.0.2.2:3333/users/$id'),
      headers: <String, String>{'Authorization': token},
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return User.fromJson(res['user']);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> logout() async {
    print("");
  }
}
