import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vidly/constants/app_colors.dart';
import 'package:vidly/controller/youtube/XYoutubeController.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class CustomYoutubePlayer extends StatelessWidget {
  final String youtubeURL;
  final double width;
  final double height;
  const CustomYoutubePlayer(this.youtubeURL,
      {Key? key, required this.width, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(XYoutubePlayerController());
    return Container(
      width: width,
      height: height,
      
      padding: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
          color: AppColors.C_darkPurple_level_3,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.C_deepPurple)),
      child: YoutubePlayerControllerProvider(
        controller: controller.controller,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: YoutubePlayerIFrame(
            controller: controller.controller,
            aspectRatio: 16/9,
            
          ),
        ),
      ),
    );
  }
}
