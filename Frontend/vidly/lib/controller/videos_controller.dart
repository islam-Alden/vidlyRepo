import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:vidly/model/videos_model.dart';

import 'package:vidly/serviaces/videos_api_service.dart';
import 'package:vidly/view/home_page/home_page_widgets/select_category_widget.dart';


class VideosController extends GetxController {

final videosFormKey = GlobalKey<FormState>();

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

  Future<void> fetchVideos(String query, List<int>? categoryID) async { 
    try {
      // Set loading state to true
      isLoading.value = true;
      searchQuery.value = query;

      // Clear previous data to free memory
      totalVideos.value = 0;


      VideoApiService videoApiService = VideoApiService(baseUrl: 'http://127.0.0.1:8000');
      FetchVideosRequest request = FetchVideosRequest(query: query, categoryID: categoryID);
      FetchVideosResponse? response = await videoApiService.fetchVideosService(request);

      // Update state with new data
      if (response != null) {
  videosList.value = List<Map<String, dynamic>>.from(response.videos);
  totalVideos.value = response.totalVideos;

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



  // Function to open the filter bottom sheet
  Future<void> openFilterBottomSheetWidget() async {
    List<int>? selectedIds = await Get.bottomSheet(
      CategoryBottomSheetWidget(),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
    // Store the selected category IDs in the controller
    selectedCategoryIds.value = selectedIds ?? [];
  }


String? validateSearchQuery(String? query){
  final regex = RegExp(r'^[a-zA-Z0-9\s]+$');
if(query == null || query.isEmpty || !regex.hasMatch(query)){
  return "Invalid input";
 }
return null; // Input is valid,
}

void onValidate(){
  if(videosFormKey.currentState!.validate()){
fetchVideos(searchQuery.value, selectedCategoryIds);


  }

}

}