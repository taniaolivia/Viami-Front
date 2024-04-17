import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/language/language.dart';

class LanguageService {
  Future<Language> getLanguageById(String token, String id) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/languages/$id'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Language.fromJson(res["data"]);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
