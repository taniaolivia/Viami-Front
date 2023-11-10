import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/themeTravel/themesTravels.dart';

class ThemesTravelsService {
  Future<ThemesTravels> getFirstFiveTravelsByTheme(
      String token, int themeId) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/themesFive/$themeId/travels'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return ThemesTravels.fromJson(res);
    } else {
      throw Exception('Failed to load travels');
    }
  }
}
