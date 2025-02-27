import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vidly/model/live_steam_model.dart';


class LiveStreamApiService {
  final String baseUrl;

  LiveStreamApiService({required this.baseUrl});

  Future<FetchLiveStreamsResponse> fetchLiveStreamsService(
      FetchLiveStreamsRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/v1/videos/live_streams/fetch'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return FetchLiveStreamsResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}

