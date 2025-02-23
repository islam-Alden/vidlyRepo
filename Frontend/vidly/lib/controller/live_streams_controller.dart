import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vidly/model/live_steam_model.dart';

import 'package:vidly/serviaces/live_stream_api_service.dart';
import 'package:vidly/view/home_page/home_page_widgets/live_stram_fliters.dart';


class LiveStreamsController extends GetxController {
  final liveStreamFormKey = GlobalKey<FormState>();

  // Observables for reactive state management
  var isLoading = false.obs;
  var totalVideos = 0.obs;
  // Observable for the selected category IDs
  var selectedCategoryIds = <int>[].obs;
  // New observables for event type and time range
  var selectedEventType = "live".obs; // Default event type
  var selectedTimeRange = "today".obs; // Default time range

  // Store fetched videos 
  var videosList = <Map<String, dynamic>>[].obs;
  var searchQuery = ''.obs;
  var videoTitle = "".obs;
  var channel = "Unknown".obs;

  Future<void> fetchLiveStreams(
    String query,
    String eventType,
    // List<int>? categoryID,
    String timeRange,
  ) async {
    try {
      // Set loading state to true and update the search query
      isLoading.value = true;
      searchQuery.value = query;
      totalVideos.value = 0;

      // Create your API service and request object
      LiveStreamApiService liveStreamApiService =
          LiveStreamApiService(baseUrl: 'http://127.0.0.1:8000');
      FetchLiveStreamsRequest request = FetchLiveStreamsRequest(
        query: query,
        eventType: eventType,
        // categoryID: categoryID,
        timeRange: timeRange,
      );

      // Fetch live streams from the API
      FetchLiveStreamsResponse? response =
          await liveStreamApiService.fetchLiveStreamsService(request);

      // Update state with new data if response is valid
      if (response != null) {
        videosList.value =
            List<Map<String, dynamic>>.from(response.videos);
        totalVideos.value = response.totalVideos;

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


  Future<void> openFilterBottomSheetWidget() async {
    final result = await Get.bottomSheet(
      LiveStreamFilterWidget(), // Your updated filter widget
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
    if (result != null && result is Map) {
      // Update the observables based on the returned filter selections.
      selectedEventType.value =
          result['selectedEventType'];
      selectedTimeRange.value =
          result['selectedTimeRange'];
    }
  }

  String? validateSearchQuery(String? query) {
    final regex = RegExp(r'^[a-zA-Z0-9\s]+$');
    if (query == null || query.isEmpty || !regex.hasMatch(query)) {
      return "Invalid input";
    }
    return null; // Input is valid.
  }

  // Call this method after form validation to fetch live streams
void onValidate() {
  if (liveStreamFormKey.currentState!.validate()) {
    // Use default values if the observables are empty.
    final eventType = selectedEventType.value.isNotEmpty ? selectedEventType.value : "live";
    final timeRange = selectedTimeRange.value.isNotEmpty ? selectedTimeRange.value : "today";
 

    fetchLiveStreams(
     searchQuery.value,
      eventType,
      timeRange,
    );
  }
}
}
