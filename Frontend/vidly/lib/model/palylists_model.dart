
class FetchPlaylistsRequest {
  final String query;
  // final List<int>? categoryID;

  FetchPlaylistsRequest( {required this.query});

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      // 'category_ids': categoryID,
    };
  }
}


class FetchPlaylistsResponse {

  // final int totalVideos;
  final List<dynamic> videos;

  FetchPlaylistsResponse( {
// required this.totalVideos,
    required this.videos,
  });

  factory FetchPlaylistsResponse.fromJson(Map<String, dynamic> json) {
    return FetchPlaylistsResponse(

 
      videos: List<dynamic>.from(json['playlists']), 
    );
  }
}
