
// RETRIEVE 
class FetchFavoriteVideosResponse {

  final int totalVideos;
  final List<dynamic> videos;

  FetchFavoriteVideosResponse( {
required this.totalVideos,
    required this.videos,
  });

  factory FetchFavoriteVideosResponse.fromJson(Map<String, dynamic> json) {
    return FetchFavoriteVideosResponse(

      totalVideos: json['total_videos'],
      videos: List<dynamic>.from(json['favorite_videos']), 
    );
  }
}



//  DELETE
class DeleteFavoriteVideoRequest {
  final String videoID;

  DeleteFavoriteVideoRequest( {required this.videoID});

  Map<String, dynamic> toJson() {
    return {
      'video_id': videoID,

    };
  }
}

class DeleteFavoriteVideoResponse {
  final String message;
  final String videoId;

  DeleteFavoriteVideoResponse({required this.message, required this.videoId});

  factory DeleteFavoriteVideoResponse.fromJson(Map<String, dynamic> json) {
    return DeleteFavoriteVideoResponse(
      message: json['message'] ?? 'No message provided',
      videoId: json['video_id'] ?? '',
    );
  }
}


// CREATE(insert)
class AddFavoriteVideoRequest {
  final String videoId;
  final String title;
  final String channel;
  final String thumbnail;
  final String publishDate; // We'll keep this as a string, similar to your Python approach
  final String duration;
  final String videoLink;

  AddFavoriteVideoRequest({
    required this.videoId,
    required this.title,
    required this.channel,
    required this.thumbnail,
    required this.publishDate,
    required this.duration,
    required this.videoLink,
  });

  // Convert this object into a JSON-friendly Map
  Map<String, dynamic> toJson() {
    return {
      'video_id': videoId,
      'title': title,
      'channel': channel,
      'thumbnail': thumbnail,
      'publish_date': publishDate,
      'duration': duration,
      'video_link': videoLink,
    };
  }
}
