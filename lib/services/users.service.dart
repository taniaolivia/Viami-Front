import 'package:viami/models-api/users.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Users> getAllUsers(String token) async {
  final response = await http.get(
    Uri.parse('http://localhost:3333/users'),
    headers: <String, String>{
      'Authorization': token,
    },
  );

  if (response.statusCode == 200) {
    var res = json.decode(response.body);

    return Users.fromJson(res);
  } else {
    throw Exception('Failed to load user');
  }
}
