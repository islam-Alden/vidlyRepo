
class FetchVideosRequest {
  final String query;
  final List<int>? categoryID;

  FetchVideosRequest( {required this.query,required this.categoryID,});

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'category_ids': categoryID,
    };
  }
}


class FetchVideosResponse {

  final int totalVideos;
  final List<dynamic> videos;

  FetchVideosResponse( {
required this.totalVideos,
    required this.videos,
  });

  factory FetchVideosResponse.fromJson(Map<String, dynamic> json) {
    return FetchVideosResponse(

      totalVideos: json['total_videos'],
      videos: List<dynamic>.from(json['videos']), 
    );
  }
}
