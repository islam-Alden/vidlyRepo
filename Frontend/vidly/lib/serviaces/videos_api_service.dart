import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:vidly/model/videos_model.dart';

class VideoApiService {
  final String baseUrl;

  VideoApiService({required this.baseUrl});

  Future<FetchVideosResponse> fetchVideosService(
      FetchVideosRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/videos/fetch'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return FetchVideosResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
