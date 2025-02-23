import 'package:get/get.dart';
import 'package:vidly/model/analysis_model.dart';
import 'package:vidly/serviaces/analysis_api_sevice.dart';
import 'package:vidly/utils/helpers/category_percentage.dart';

class AnalysisController extends GetxController {
  // Observables for reactive state management
  var isLoading = false.obs;
  var totalComments = 0.obs;
  var positiveComments = 0.obs;
  var neutralComments = 0.obs;
  var negativeComments = 0.obs;
  var fetchedVideoTitle = "".obs;

  // Function to fetch and analyze comments
  Future<void> fetchComments(String videoUrl) async {
    try {
      // Set loading state to true
      isLoading.value = true;

      // Clear previous data to free memory
      totalComments.value = 0;
      positiveComments.value = 0;
      neutralComments.value = 0;
      negativeComments.value = 0;
      fetchedVideoTitle.value = "";

      // Fetch analyzed comments
      ApiService apiService = ApiService(baseUrl: 'http://127.0.0.1:8000');
      FetchCommentsRequest request = FetchCommentsRequest(url: videoUrl);
      FetchCommentsResponse? response = await apiService.fetchAndAnalyzeComments(request);

      // Update state with new data
      if (response != null) {
        totalComments.value = response.commentsFetched;
        positiveComments.value = response.classificationCounts['Positive'] ?? 0;
        neutralComments.value = response.classificationCounts['Neutral'] ?? 0;
        negativeComments.value = response.classificationCounts['Negative'] ?? 0;
        fetchedVideoTitle.value = response.videoTitle;
      }

      // Free memory after processing
      response = null;

    } catch (e) {
      print("Error fetching comments: $e");
    } finally {
      // Set loading state to false
      isLoading.value = false;
    }
  }

  // Use the helper class to calculate percentages dynamically
  Map<String, int> get percentages => CategoryPercentageCalculator.calculate(
        totalComments.value,
        positiveComments.value,
        neutralComments.value,
        negativeComments.value,
      );

  int get positivePercentage => percentages['Positive'] ?? 0;
  int get neutralPercentage => percentages['Neutral'] ?? 0;
  int get negativePercentage => percentages['Negative'] ?? 0;
}