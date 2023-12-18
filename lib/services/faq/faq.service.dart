import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/models-api/faqs/FaqData.dart';

class FaqService {
  Future<Faq> getFaqById(int faqId, String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/faq/$faqId'),
      headers: <String, String>{'Authorization': token},
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Faq.fromJson(res["data"][0]);
    } else {
      throw Exception('Failed to load faq');
    }
  }
}
