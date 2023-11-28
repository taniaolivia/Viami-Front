import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/messenger/messages.dart';
import 'package:viami/models-api/userGroup/groupUsers.dart';

class GroupUsersService {
  Future<GroupUsers> getAllUsersGroup(
      String token, int groupId, String userId) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/groups/$groupId/$userId/users'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      return GroupUsers.fromJson(res);
    } else {
      throw Exception('Failed to load messages');
    }
  }
}
