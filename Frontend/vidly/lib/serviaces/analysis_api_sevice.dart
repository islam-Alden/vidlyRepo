import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vidly/model/analysis_model.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<FetchCommentsResponse> fetchAndAnalyzeComments(
      FetchCommentsRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/v1/comments/fetch'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return FetchCommentsResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
