import 'package:flutter/material.dart';
import 'package:vidly/constants/app_icons.dart';
import 'package:vidly/controller/favorite_videos_controller.dart';
import 'package:vidly/utils/reuesable_widgets/custom_text_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:vidly/constants/app_colors.dart';
import 'package:vidly/constants/app_strings.dart';
import 'package:vidly/controller/youtube_video_palyer_controller.dart';
import 'package:vidly/utils/reuesable_widgets/custom_container.dart';
import 'package:vidly/utils/reuesable_widgets/video_details.dart';
import 'package:vidly/utils/reuesable_widgets/youtube_widget.dart';
import 'package:vidly/utils/screen_util.dart';



class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final youtubeController = Get.put(XYoutubePlayerController());
  final favoriteVideosController = Get.put(FavoriteVideosController());

  @override
  void initState() {
    super.initState();
    // If you want to force a fresh fetch each time the page is shown,
    // you could call fetchFavoriteVideos() here.
    favoriteVideosController.fetchFavoriteVideos();
  }

  @override
  Widget build(BuildContext context) {
    final screenUtil = ScreenUtil(context);

    // This puts the FavoriteVideosController into memory,
    // which will trigger onInit() -> fetchFavoriteVideos()
    final favoriteVideosController = Get.put(FavoriteVideosController());

    return Column(
      children: [
        SizedBox(
          height: 19,
        ),
        CustomYoutubePlayer(
          'https://youtu.be/2pgO8-nmgfE',
          width: screenUtil.scaleWidth(0.95),
          height: screenUtil.scaleHeight(0.27),
        ),
        SizedBox(
          height: 5,
        ),
        Obx(() {
          if (favoriteVideosController.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              children: [
                Obx(() {
                  return Container(
                    alignment: Alignment.topCenter,
                    // color:Colors.black38,
                    width: screenUtil.scaleWidth(0.95),
                    height: screenUtil.scaleHeight(0.06),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          fontSize: screenUtil.aspectRatio * 42,
                          color: AppColors.C_purple,
                          textAlign: TextAlign.center,
                          enableScrolling: true,
                          text: favoriteVideosController
                                  .videoTitle.value.isNotEmpty
                              ? favoriteVideosController.videoTitle.value
                              : "No Title Available",
                        ),
                      ],
                    ),
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                CustomContainer(
                    width: screenUtil.scaleWidth(0.95),
                    height: screenUtil.scaleHeight(0.48),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: screenUtil.scaleWidth(0.2),
                        height: screenUtil.scaleHeight(0.2),
                        child: Obx(() {
                          if (favoriteVideosController.isLoading.value) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (favoriteVideosController.videosList.isEmpty) {
                            return Center(
                                child: CustomText(
                              text: "No videos found.",
                              color: AppColors.C_purple,
                            ));
                          }
                
                          return ListView.builder(
                              itemCount:
                                  favoriteVideosController.videosList.length,
                              itemBuilder: (context, index) {
                                var video =
                                    favoriteVideosController.videosList[index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomContainer(
                                      width: screenUtil.scaleWidth(0.55),
                                      height: screenUtil.scaleHeight(0.14),
                                      child: VideoDetailsWidget(
                                        imagePath: video["thumbnail"],
                                        videoTitle: video['title'],
                                        channelName: video['channel'],
                                        videoDate: video["publish_date"],
                                        videoLength: video["duration"],
                                        copy: AppStrings.S_copy,
                                        onCopyButtonPressed: () {
                                          Clipboard.setData(ClipboardData(
                                              text: video["video_link"]));
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
                                          youtubeController.changeVideo(
                                              "https://youtu.be/${video["video_id"]}");
                
                                          favoriteVideosController.videoTitle
                                              .value = video['title'];
                                        },
                                        onActionButtonPressed: () {
                                          favoriteVideosController
                                              .deleteFavoriteVideo(
                                                  video["video_id"]);
                                        },
                                        actionButtonIcon: AppIcons.I_delete,
                                      )),
                                );
                              });
                        }),
                      ),
                    ))
              ],
            );
          }
        }),
      ],
    );
  }
}
