import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/travel/travel.dart';

import '../../models-api/travel/travels.dart';

class RecommendedTravelsService {
  Future<Travels> getAllRecommendedTravels() async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/recommended-travels'),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Travels.fromJson(res);
    } else {
      throw Exception('Failed to load Recommended travels');
    }
  }
}
