import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../models-api/userStatus/userStatus.dart';
import 'package:http/http.dart' as http;

class UserStatusService {
  Future<UserStatus> getUserStatusById(String? id, String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/users/userStatus/$id'),
      headers: <String, String>{'Authorization': token},
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      print("statusssssssssssssssss");
      print(res['userStatus']);

      return UserStatus.fromJson(res['userStatus']);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
