
import 'package:get/get.dart';

import 'package:vidly/model/playlists_videos_model.dart';
import 'package:vidly/serviaces/playlists_api_service.dart';



class PlaylistVideosController extends GetxController {



  // Observables for reactive state management
  var isLoading = false.obs;
  var totalVideos = 0.obs;
    // Observable for the selected category IDs (optional)
  var selectedCategoryIds = <int>[].obs;
  // Store fetched videos 
  var videosList = <Map<String, dynamic>>[].obs; 
  var searchQuery = ''.obs;

var videoTitle = "".obs;
var channel = "Unknown".obs;

  Future<void> fetchPlaylistVideos(String playlistID) async {
    try {
      // Set loading state to true
      isLoading.value = true;
      // searchQuery.value = playlistID;

      // Clear previous data to free memory
      totalVideos.value = 0;

      PlaylistVideosApiService playlistVideosApiService = PlaylistVideosApiService(baseUrl: 'http://127.0.0.1:8000');
      FetchPlaylistVideosRequest request = FetchPlaylistVideosRequest(playlistID: playlistID);
      FetchPlaylistVideosResponse? response = await playlistVideosApiService.fetchPlaylistVideosService(request);

      // Update state with new data
      if (response != null) {
  videosList.value = List<Map<String, dynamic>>.from(response.videos);
  videoTitle = response.videos[0];
  // totalVideos.value = response.totalVideos;

        print(response.videos);
        // print(response.totalVideos);

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
  
  }