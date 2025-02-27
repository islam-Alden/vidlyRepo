import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vidly/model/favorite_videos_model.dart';

class FavoriteVideosApiService {
  final String baseUrl;

  FavoriteVideosApiService({required this.baseUrl});

  Future<FetchFavoriteVideosResponse> fetchFavoriteVideosService() async {
    final response = await http.get(
      Uri.parse('$baseUrl/v1/videos/favorites/fetch'),
);

    if (response.statusCode == 200) {
      return FetchFavoriteVideosResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}



class FavoriteVideosDeleteApiService {
  final String baseUrl;

  FavoriteVideosDeleteApiService({required this.baseUrl});

  Future<DeleteFavoriteVideoResponse> deleteFavoriteVideosService(DeleteFavoriteVideoRequest request) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/v1/videos/favorites/delete'),
            headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(request.toJson()),
);

    if (response.statusCode == 200) {
           final Map<String, dynamic> data = json.decode(response.body);
      return DeleteFavoriteVideoResponse.fromJson(data);
    } else {
throw Exception('Failed to delete video. Status: ${response.statusCode}');    }
  }
}


class FavoriteVideosAddApiService {
  final String baseUrl;

  FavoriteVideosAddApiService({required this.baseUrl});

  Future<void> addVideo(AddFavoriteVideoRequest video) async {
    // The endpoint expects a list of videos, so we wrap
    // our single video in a list.
    final List<Map<String, dynamic>> requestBody = [video.toJson()];

    final response = await http.post(
      Uri.parse('$baseUrl/v1/videos/favorites/insert'), 
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      // The server returned 200, meaning success
      print('Video added successfully!');
      // If your endpoint returns JSON, you could parse it here:
      // final Map<String, dynamic> data = json.decode(response.body);
      // print(data['message']);
    } else {
      throw Exception('Failed to add video. Status code: ${response.statusCode}');
    }
  }
}
