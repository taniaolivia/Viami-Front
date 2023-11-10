import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../models-api/travel/travel.dart';
import '../../models-api/travel/travels.dart';

class RecommendedTravelsService {
  Future<Travels> getAllRecommendedTravels(String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/recommend/travels'),
      headers: <String, String>{
        'Authorization': token,
      },
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    print("serviceee");

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Travels.fromJson(res);
    } else {
      throw Exception('Failed to load Recommended travels');
    }
  }

  Future<Travel> getRecommendTravelById(String travelId, String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/recommend/travels/$travelId'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      print(res['travel']);

      return Travel.fromJson(res['travel']);
    } else {
      throw Exception('Failed to load travel');
    }
  }
}
