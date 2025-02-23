class FetchLiveStreamsRequest {
  final String query;
  final String eventType;
  final String timeRange;
  // final List<int>? categoryID;

  FetchLiveStreamsRequest(
      {required this.query,
      required this.eventType,
      required this.timeRange});

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'event_type': eventType,
      'upcoming_live_stream_time_range': timeRange
    };
  }
}

class FetchLiveStreamsResponse {
  final int totalVideos;
  final List<dynamic> videos;

  FetchLiveStreamsResponse({
    required this.totalVideos,
    required this.videos,
  });

  factory FetchLiveStreamsResponse.fromJson(Map<String, dynamic> json) {
    return FetchLiveStreamsResponse(
      totalVideos: json['total_videos'],
      videos: List<dynamic>.from(json['videos']),
    );
  }
}
