import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../models-api/faqs/faqDatas.dart';

class FaqsService {
  Future<Faqs> getAllFaq(String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/faq'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Faqs.fromJson(res);
    } else {
      throw Exception('Failed to load faqs');
    }
  }

  Future<Faqs> getTopFiveFrequentedFaq(String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/frequentedFive/faq'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Faqs.fromJson(res);
    } else {
      throw Exception('Failed to load faqs');
    }
  }

  Future<Faqs> searchFaqByKeyword(String token, String keyword) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/faq/search/$keyword'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      return Faqs.fromJson(res);
    } else {
      throw Exception('Failed to load faqs');
    }
  }
}
