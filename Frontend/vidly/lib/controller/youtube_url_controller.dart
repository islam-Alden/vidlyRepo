import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vidly/controller/analysis_controller.dart';
import 'package:vidly/controller/youtube_video_palyer_controller.dart';
import 'package:vidly/utils/helpers/extract_video_id.dart';

class AnalysisSearchBarController extends GetxController{

final formKey = GlobalKey<FormState>();
    final youtubeController = Get.put(XYoutubePlayerController());
    final analysisController = Get.put(AnalysisController());

// var videoID = "".obs;
var url = "".obs;

String? validateUserInput(String? text){
if(text == null || text.isEmpty ){
  return "Invalid URL";
 }

 String? urlError = youtubeUrlValidator(text);

 if(urlError != null){
  return urlError; // return the error message
 }

String? extractedValidVideoID = extractVideoId(text);

if(extractedValidVideoID == null){
  return "Invalid YouTube Video ID";
}

// videoID.value = extractedValidVideoID;
url.value = "https://youtu.be/$extractedValidVideoID";
return null; // the input is valid
}

// test()async{
//          youtubeController.changeVideo(url.value);
// await analysisController.fetchComments(url.value);
// }

// validate the user input when he presses the send button
// onValidate(){
//   formKey.currentState!.validate();



// }

// validate the user input when he presses the send button
void onValidate()async{
  if(formKey.currentState!.validate()){
youtubeController.changeVideo(url.value);
await analysisController.fetchComments(url.value);
  }

}

}