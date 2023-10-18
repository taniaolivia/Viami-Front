import 'package:viami/models-api/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
            "lastConnection": ""
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
      "message": res['message']
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

    return User.fromJson(res);
  } else {
    throw Exception('Failed to load user');
  }
}

Future<bool> deleteUserById(String id, String token) async {
  const String baseUrl = 'http://localhost:3333';

  final String deleteUserByIdUrl = '$baseUrl/users/$id';

  try {
    final response = await http.delete(
      Uri.parse(deleteUserByIdUrl),
      headers: <String, String>{'Authorization': token},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print(data['message']);
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
