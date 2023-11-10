import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/theme/themes.dart';

class ThemessService {
  Future<Themes> getAllThemes(String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/themes'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Themes.fromJson(res);
    } else {
      throw Exception('Failed to load travels');
    }
  }
}
