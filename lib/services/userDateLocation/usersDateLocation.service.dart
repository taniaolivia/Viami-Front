import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/themeActivity/themeActivities.dart';
import 'package:viami/models-api/userDateLocation/usersDateLocation.dart';

class UsersDateLocationService {
  Future<UsersDateLocation> getAllParticipantsTravel(
      String token, String location, String date) async {
    final response = await http.get(
      Uri.parse(
          '${dotenv.env['API_URL']}/travelUsers?location=$location&date=$date'),
      headers: <String, String>{
        'Authorization': token,
      },
    );


    if (response.statusCode == 200) {
      var res = json.decode(response.body);

print(res["userDateLocation"]);
      return UsersDateLocation.fromJson(res["userDateLocation"]);
    } else {
      throw Exception("Failed to load date location's users");
    }
  }

  Future<String> joinTravel(
      String token, String userId, String location, String date) async {
    final response = await http.patch(
        Uri.parse('${dotenv.env['API_URL']}/travelUsers/add'),
        headers: <String, String>{
          "Content-Type": "application/json",
          'Authorization': token,
        },
        body: jsonEncode(<String, dynamic>{
          "userId": userId,
          "location": location,
          "date": date
        }));

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return res['message'];
    } else {
      throw Exception("Failed to add user to the trip");
    }
  }
}
