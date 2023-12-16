import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RequestMessagService {
  Future<void> answerRequest(String token, int requestId, int answer,
      String title, String content, String fcmToken) async {
    final response = await http.patch(
        Uri.parse('${dotenv.env['API_URL']}/send/answerRequest'),
        headers: <String, String>{
          "Content-Type": "application/json",
          'Authorization': token,
        },
        body: jsonEncode(<String, dynamic>{
          "requestId": requestId,
          "answer": answer,
          "title": title,
          "content": content,
          "fcmToken": fcmToken
        }));

    print(response.body);
    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return res;
    } else {
      throw Exception('Failed to load requests messages');
    }
  }

  Future<void> sendRequest(String token, String requesterId, String receiverId,
      String title, String content, String fcmToken) async {
    final response = await http.post(
        Uri.parse('${dotenv.env['API_URL']}/send/requestMessage'),
        headers: <String, String>{
          "Content-Type": "application/json",
          'Authorization': token,
        },
        body: jsonEncode(<String, dynamic>{
          "requesterId": requesterId,
          "receiverId": receiverId,
          "title": title,
          "content": content,
          "fcmToken": fcmToken
        }));

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return res;
    } else {
      throw Exception('Failed to load requests messages');
    }
  }
}
