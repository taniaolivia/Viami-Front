import 'package:viami/models-api/interest.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class InterestService {
  Future<Interest> getInterestById(String token, String id) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/interests/$id'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Interest.fromJson(res["data"]);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
