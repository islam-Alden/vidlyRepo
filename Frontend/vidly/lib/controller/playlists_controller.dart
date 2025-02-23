import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vidly/model/palylists_model.dart';


import 'package:vidly/serviaces/playlists_api_service.dart';


class PlaylistsController extends GetxController {

  final playlistsFormKey = GlobalKey<FormState>();

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

  Future<void> fetchPlaylists(String query) async {
    try {
      // Set loading state to true
      isLoading.value = true;
      searchQuery.value = query;

      // Clear previous data to free memory
      totalVideos.value = 0;

      PlaylistsApiService playlistsApiService = PlaylistsApiService(baseUrl: 'http://127.0.0.1:8000');
      FetchPlaylistsRequest request = FetchPlaylistsRequest(query: query);
      FetchPlaylistsResponse? response = await playlistsApiService.fetchPlaylistsService(request);

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

    String? validateSearchQuery(String? query) {
    final regex = RegExp(r'^[a-zA-Z0-9\s]+$');
    if (query == null || query.isEmpty || !regex.hasMatch(query)) {
      return "Invalid input";
    }
    return null; // Input is valid.
  }

  void onValidate(){
  if(playlistsFormKey.currentState!.validate()){
fetchPlaylists(searchQuery.value);


  }

}
  
  }