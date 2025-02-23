
class FetchPlaylistVideosRequest {
  final String playlistID;
  // final List<int>? categoryID;

  FetchPlaylistVideosRequest( {required this.playlistID});

  Map<String, dynamic> toJson() {
    return {
      'playlist_id': playlistID,
    };
  }
}


class FetchPlaylistVideosResponse {

  // final int totalVideos;
  final List<dynamic> videos;

  FetchPlaylistVideosResponse( {
// required this.totalVideos,
    required this.videos,
  });

  factory FetchPlaylistVideosResponse.fromJson(Map<String, dynamic> json) {
    return FetchPlaylistVideosResponse(

      // totalVideos: json['total_videos'],
      videos: List<dynamic>.from(json['playlist_videos']), 
    );
  }
}
