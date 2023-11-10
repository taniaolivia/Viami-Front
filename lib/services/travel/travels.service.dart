import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/travel/travels.dart';

import '../../models-api/travel/travel.dart';

class TravelsService {
  Future<Travels> getAllTravels(String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/travels'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Travels.fromJson(res);
    } else {
      throw Exception('Failed to load travels');
    }
  }

  Future<Travel> getTravelById(String travelId, String token) async {
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

  Future<Travels> searchTravels(String token, String location) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/search/travels?location=$location'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Travels.fromJson(res);
    } else {
      throw Exception('Failed to load travels');
    }
  }

  Future<Travels> getAllPopularTravels(String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/popular/travels'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Travels.fromJson(res);
    } else {
      throw Exception('Failed to load travels');
    }
  }

  Future<Travels> getFivePopularTravels(String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/popularFive/travels'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Travels.fromJson(res);
    } else {
      throw Exception('Failed to load travels');
    }
  }
}
