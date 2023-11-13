import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/travel/travel.dart';

class TravelService {
  Future<Travel> getTravelById(int travelId, String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/travels/$travelId'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Travel.fromJson(res['travel'][0]);
    } else {
      throw Exception('Failed to load travel');
    }
  }
}
