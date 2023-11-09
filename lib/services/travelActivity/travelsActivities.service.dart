import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models-api/travelActivity/travelsActivities.dart';

class TravelsActivitiesService {
  Future<TravelsActivities> getAllTravelActivities(String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/travelActivities'),
      headers: <String, String>{'Authorization': token},
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return TravelsActivities.fromJson(res['data']);
    } else {
      throw Exception('Failed to load travel activities');
    }
  }

  Future<TravelsActivities> getTravelActivitiesById(
      String travelId, String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/travels/$travelId/activities'),
      headers: <String, String>{'Authorization': token},
    );

    print(response);
    print("body");
    print(response.body);

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      print("ress");
      print(res["travelActivities"]);

      return TravelsActivities.fromJson(res);
    } else {
      throw Exception('Failed to load travel activities');
    }
  }
}
