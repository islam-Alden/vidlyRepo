import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vidly/model/palylists_model.dart';
import 'package:vidly/model/playlists_videos_model.dart';



class PlaylistsApiService {
  final String baseUrl;

  PlaylistsApiService({required this.baseUrl});

  Future<FetchPlaylistsResponse> fetchPlaylistsService(
      FetchPlaylistsRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/videos/fetch_playlists'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return FetchPlaylistsResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class PlaylistVideosApiService {
  final String baseUrl;

  PlaylistVideosApiService({required this.baseUrl});

  Future<FetchPlaylistVideosResponse> fetchPlaylistVideosService(
      FetchPlaylistVideosRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/videos/fetch_playlist_videos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return FetchPlaylistVideosResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
