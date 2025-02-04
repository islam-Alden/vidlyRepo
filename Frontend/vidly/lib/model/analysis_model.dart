
// This class handles dealing with link data
// for both sending and receiving link information

class FetchCommentsRequest {
  final String url;

  FetchCommentsRequest({required this.url});

  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }
}


class FetchCommentsResponse {
  final String videoId;
  final String videoTitle;
  final int commentsFetched;
  final Map<String, int> classificationCounts;

  FetchCommentsResponse({
    required this.videoId,
    required this.videoTitle,
    required this.commentsFetched,
    required this.classificationCounts,
  });

  factory FetchCommentsResponse.fromJson(Map<String, dynamic> json) {
    return FetchCommentsResponse(
      videoId: json['video_id'],
      videoTitle: json['video_title'],
      commentsFetched: json['comments_fetched'],
      classificationCounts: Map<String, int>.from(json['classification_counts']),
    );
  }
}




