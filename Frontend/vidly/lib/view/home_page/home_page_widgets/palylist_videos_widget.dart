import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vidly/constants/app_colors.dart';
import 'package:vidly/constants/app_icons.dart';
import 'package:vidly/constants/app_strings.dart';
import 'package:vidly/controller/favorite_videos_controller.dart';
import 'package:vidly/controller/playlitst_videos_controller.dart';
import 'package:vidly/controller/youtube_video_palyer_controller.dart';
import 'package:vidly/utils/helpers/snack_bar.dart';
import 'package:vidly/utils/reuesable_widgets/custom_container.dart';
import 'package:vidly/utils/reuesable_widgets/custom_text_widget.dart';
import 'package:vidly/utils/reuesable_widgets/video_details.dart';
import 'package:vidly/utils/screen_util.dart';

class PlaylistVideosBottomSheet extends StatelessWidget {
  final String playlistId;

  const PlaylistVideosBottomSheet({Key? key, required this.playlistId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize or retrieve the controller.
    final PlaylistVideosController controller =
        Get.put(PlaylistVideosController());
    final youtubeController = Get.put(XYoutubePlayerController());
        final favoriteVideosController = Get.put(FavoriteVideosController());
    final ScreenUtil screenUtil = ScreenUtil(context);
    // Fetch playlist videos when the widget is built.
    controller.fetchPlaylistVideos(playlistId);

    return DraggableScrollableSheet(
      initialChildSize: 0.4, // starting height fraction
      minChildSize: 0.2, // collapsed height fraction
      maxChildSize: 0.9, // expanded height fraction
      builder: (context, scrollController) {
        return CustomContainer(
          backgroundColor: AppColors.C_darkPurple_level_4,
          width: screenUtil.width,
          child: Column(
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 5,
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Header row with title and close button.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomText(
                          text: AppStrings.playlistVideos,
                          color: AppColors.C_lightBlue),
                    ),
                    IconButton(
                      icon: Icon(
                        AppIcons.I_closeIcon,
                        color: AppColors.C_lightBlue,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
              Divider(),

              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (controller.videosList.isEmpty) {
                    return Center(child: Text("No videos found."));
                  }
                  return ListView.builder(
                    controller: scrollController,
                    itemCount: controller.videosList.length,
                    itemBuilder: (context, index) {
                      var video = controller.videosList[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomContainer(
                            width: screenUtil.scaleWidth(0.55),
                            height: screenUtil.scaleHeight(0.14),
                            borderColor: AppColors.C_transparent,
                            borderWidth: 0.0,
                            child: VideoDetailsWidget(
                              imagePath: video["thumbnail"],
                              videoTitle: video['title'],
                              channelName: video['channel'],
                              videoDate: video["publish_date"],
                              videoLength: video["duration"],
                              copy: AppStrings.S_copy,
  
                              onCopyButtonPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: video["video_link"]));
                                Get.snackbar(
                                  "Copied!",
                                  "Copied to clipboard.",
                                  snackPosition: SnackPosition
                                      .TOP, // Shows snackbar at the bottom
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                  duration: Duration(seconds: 2),
                                );
                              },
                              onThumbnailPressed: () {
                                // Build the video URL.
                                final videoUrl =
                                    "https://youtu.be/${video["video_id"]}";

                                // Change the video via youtubeController.
                                youtubeController.changeVideo(videoUrl);

                                // you can add logic to show video title instead of playlist title

                                // Optionally, dismiss the bottom sheet after playing a video.
                                Get.back();
                              },
                                                                   onActionButtonPressed: () {
                                            favoriteVideosController
                                                .addFavoriteVideo(
                                                    videoId: video["video_id"],
                                                    title: video['title'],
                                                    channel: video['channel'],
                                                    thumbnail:
                                                        video["thumbnail"],
                                                        // the date value is fake and just for test
                                                        // because the publish_date is not included 
                                                        // so the stored value is always "01 01 2025"
                                                    publishDate:
                                                        video["publish_date"] ??"01 01 2025",
                                                    duration: video["duration"] ?? "Unknown",
                                                    videoLink:
                                                        video["video_link"]);

                                            customSnackBar(
                                                "Added!",
                                                "Added to Favorite.",
                                                AppColors.C_green,
                                                AppColors.C_white);
                                          },
                                          actionButtonIcon: AppIcons.I_favorite,
                            )),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
