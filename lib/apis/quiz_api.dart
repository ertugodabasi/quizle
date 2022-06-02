import 'dart:convert';

import 'package:http/http.dart' as http;

class QuizApi {
  static const headers = {
    'Accept': 'application/json, text/plain, */*',
    'Accept-Language': 'tr-TR,tr;q=0.9,en-US;q=0.8,en;q=0.7',
    'Connection': 'keep-alive'
  };

  static Future<Map<String, dynamic>> getQuestion(int difficulty) async {
    final url = Uri.parse(
        'https://quiz-it-api.herokuapp.com/api/question/?difficulty=$difficulty');

    final response = await http.get(url, headers: headers);
    final data = json.decode(response.body) as Map<String, dynamic>;
    return data['results'];
  }

  static Future<Map<String, dynamic>> getAvailableRoom(int difficulty) async {
    final url = Uri.parse(
        'https://quiz-it-api.herokuapp.com/api/socket/find-avalible-room');

    final response = await http.get(url, headers: headers);
    final data = json.decode(response.body) as Map<String, dynamic>;
    return data;
  }
}
