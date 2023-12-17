import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MessageService {
  Future<void> setMessageRead(
      String token, int messageId, String userId) async {
    final response = await http.post(
        Uri.parse(
            '${dotenv.env['API_URL']}/messages/$messageId?userId=$userId'),
        headers: <String, String>{
          'Authorization': token,
        });

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return res;
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<void> sendMessage(String token, int? groupId, String message,
      String? senderId, String? responderId) async {
    final response =
        await http.post(Uri.parse('${dotenv.env['API_URL']}/sendMessage'),
            headers: <String, String>{
              'Authorization': token,
            },
            body: jsonEncode(<String, dynamic>{
              "groupId": groupId,
              "message": message,
              "senderId": senderId,
              "responderId": responderId,
            }));

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      print("ress message sendd ");
      print(res);

      return res;
    } else {
      throw Exception('Failed to load messages');
    }
  }
}
