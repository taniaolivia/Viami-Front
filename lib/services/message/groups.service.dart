import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../models-api/messenger/groups_data.dart';
import 'package:http/http.dart' as http;

class GroupsService {
  Future<Groups> getAllDiscussionsForUser(String token, String userId) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/discussions/$userId'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      print("ressssssssssssss");
      print(res);
      print("resss discusionssss");
      print(res["discussions"]);

      return Groups.fromJson(res);
    } else {
      throw Exception('Failed to load travels');
    }
  }
}
