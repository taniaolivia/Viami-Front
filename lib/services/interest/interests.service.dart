import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/interest/interests.dart';

class InterestsService {
  Future<Interests> getAllInterests(String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/interests'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Interests.fromJson(res);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
