import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/requestMessage/requests_messages.dart';

class RequestsMessageService {
  Future<RequestsMessages> getAllRequestsMessagesByUser(
      String token, String receiverId) async {
    final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/requestsMessages/$receiverId'),
        headers: <String, String>{
          'Authorization': token,
        });

    print(response.body);
    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return RequestsMessages.fromJson(res);
    } else {
      throw Exception('Failed to load requests messages');
    }
  }

  Future<RequestsMessages> getAllRequestsAcceptedByUser(
      String token, String userId) async {
    final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/requestsMessages/$userId/accepted'),
        headers: <String, String>{
          'Authorization': token,
        });

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return RequestsMessages.fromJson(res);
    } else {
      throw Exception('Failed to load requests messages');
    }
  }
}
