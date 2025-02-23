
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vidly/model/favorite_videos_model.dart';
import 'package:vidly/serviaces/favorite_videos_api_service.dart';



class FavoriteVideosController extends GetxController {


  // Observables for reactive state management
  var isLoading = false.obs;
  var totalVideos = 0.obs;

  // Store fetched videos
  var videosList = <Map<String, dynamic>>[].obs;

  var videoTitle = "".obs;
  var channel = "Unknown".obs;


  @override
  // void onInit() {
  //   super.onInit();
  //   fetchFavoriteVideos(); // Call it here so it runs when the controller is created
  // }

  Future<void> fetchFavoriteVideos() async {
    try {
      // Set loading state to true
      isLoading.value = true;

      // Clear previous data to free memory
      totalVideos.value = 0;

      FavoriteVideosApiService favoriteVideosApiService =
          FavoriteVideosApiService(baseUrl: 'http://127.0.0.1:8000');

      FetchFavoriteVideosResponse? response =
          await favoriteVideosApiService.fetchFavoriteVideosService();

      // Update state with new data
      if (response != null) {
        videosList.value = List<Map<String, dynamic>>.from(response.videos);
        // videoTitle = response.videos[0];
        totalVideos.value = response.totalVideos;

        // If there's at least one video, extract its title/channel
        if (videosList.isNotEmpty) {
          videoTitle.value = videosList[0]['title'] ?? 'No Title';
          channel.value = videosList[0]['channel'] ?? 'Unknown';
        }
        print(response.videos);
        print(response.totalVideos);
      }

      // Free memory after processing
      response = null;
    } catch (e) {
      print("Error fetching videos: $e");
    } finally {
      // Set loading state to false
      isLoading.value = false;
    }
  }

  final FavoriteVideosDeleteApiService deleteApiService =
      FavoriteVideosDeleteApiService(baseUrl: 'http://127.0.0.1:8000');

  Future<void> deleteFavoriteVideo(String videoId) async {
    try {
      // 1. Create the request object
      final request = DeleteFavoriteVideoRequest(videoID: videoId);

      // 2. Call the service and get the parsed response
      final response = await deleteApiService.deleteFavoriteVideosService (request);

    // 3. Remove the video locally so the UI updates immediately
    videosList.removeWhere((video) => video["video_id"] == videoId);
      // 3. Show success SnackBar
      Get.snackbar(
        "Success",
        response.message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF4CAF50),
        colorText: const Color(0xFFFFFFFF),
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      // 4. Show error SnackBar
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFFF5252),
        colorText: const Color(0xFFFFFFFF),
        duration: const Duration(seconds: 2),
      );
    }
  }

final favoriteVideosAddApiService = FavoriteVideosAddApiService(baseUrl: 'http://127.0.0.1:8000');

  Future<void> addFavoriteVideo({
    required String videoId,
    required String title,
    required String channel,
    required String thumbnail,
    required String publishDate,
    required String duration,
    required String videoLink,
  }) async {
    try {
      // 1. Create the request object
      final newVideo = AddFavoriteVideoRequest(
        videoId: videoId,
        title: title,
        channel: channel,
        thumbnail: thumbnail,
        publishDate: publishDate,
        duration: duration,
        videoLink: videoLink,
      );

    await favoriteVideosAddApiService.addVideo(newVideo);

    // Show success message or refresh UI
    print("Video added!");
  } catch (e) {
    // Show error message
    print("Error adding video: $e");
  }
}


}
