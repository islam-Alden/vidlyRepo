import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vidly/constants/app_colors.dart';
import 'package:vidly/constants/app_icons.dart';
import 'package:vidly/constants/app_paths.dart';
import 'package:vidly/constants/app_strings.dart';
import 'package:vidly/controller/favorite_videos_controller.dart';
import 'package:vidly/controller/videos_controller.dart';

import 'package:get/get.dart';
import 'package:vidly/controller/youtube_video_palyer_controller.dart';
import 'package:vidly/utils/helpers/snack_bar.dart';
import 'package:vidly/utils/reuesable_widgets/custom_container.dart';
import 'package:vidly/utils/reuesable_widgets/custom_search_bar.dart';
import 'package:vidly/utils/reuesable_widgets/custom_text_widget.dart';
import 'package:vidly/utils/reuesable_widgets/video_details.dart';
import 'package:vidly/utils/reuesable_widgets/youtube_widget.dart';
import 'package:vidly/utils/screen_util.dart';
import 'package:vidly/view/home_page/home_page_widgets/filter_widget.dart';

class VideosPage extends StatelessWidget {
  const VideosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final videosController = Get.put(VideosController());
    final youtubeController = Get.put(XYoutubePlayerController());
    final favoriteVideosController = Get.put(FavoriteVideosController());
    final ScreenUtil screenUtil = ScreenUtil(context);

    // Initialize controllers
    final textFieldController = TextEditingController();

    return Column(
      children: [
        SizedBox(
          height: 19,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomContainer(
              width: screenUtil.scaleWidth(0.11),
              height: screenUtil.scaleHeight(0.06),
              borderRadius: 12,
              child: FilterWidget.FilterButton(
                iconColor: AppColors.C_purple,
                iconPath: AppPaths.P_filterIcon,
                onIconPressed: videosController.openFilterBottomSheetWidget,
              ),
            ),
            Container(
              width: screenUtil.scaleWidth(0.77),
              height: screenUtil.scaleHeight(0.06),
              child: Form(
                key: videosController.videosFormKey,
                child: CustomSearchBar(
                    controller: textFieldController,
                    validator: videosController.validateSearchQuery,
                    onChanged: (value) => videosController.searchQuery.value =
                        value, // Update GetX variable
                    prefixIcon: AppIcons.I_linkIcon,
                    textFieldLabel: AppStrings.S_videosSearchBarLabel,
                    textFieldHint: AppStrings.S_videosSearchBarHint,
                    suffixIcon: AppIcons.I_arrowForward,
                    onSuffixIconPressed: videosController.onValidate),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 28,
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
          if (videosController.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              children: [
                Obx(() {
                  return Container(
                    alignment: Alignment.topCenter,
                    //color: Colors.black38,
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
                          text: videosController.videoTitle.value.isNotEmpty
                              ? videosController.videoTitle.value
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
                    height: screenUtil.scaleHeight(0.36),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: screenUtil.scaleWidth(0.2),
                        height: screenUtil.scaleHeight(0.2),
                        child: Obx(() {
                          if (videosController.isLoading.value) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (videosController.videosList.isEmpty) {
                            return Center(
                                child: CustomText(
                              text: "No videos found.",
                              color: AppColors.C_purple,
                            ));
                          }

                          return ListView.builder(
                              itemCount: videosController.videosList.length,
                              itemBuilder: (context, index) {
                                var video = videosController.videosList[index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Expanded(
                                    child: CustomContainer(
                                        width: screenUtil.scaleWidth(0.57),
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
                                            customSnackBar(
                                                "Copied!",
                                                "Copied to clipboard.",
                                                AppColors.C_green,
                                                AppColors.C_white);
                                          },
                                          onThumbnailPressed: () {
                                            youtubeController.changeVideo(
                                                "https://youtu.be/${video["video_id"]}");
                                            videosController.videoTitle.value =
                                                video['title'];
                                          },
                                          onActionButtonPressed: () {
                                            favoriteVideosController
                                                .addFavoriteVideo(
                                                    videoId: video["video_id"],
                                                    title: video['title'],
                                                    channel: video['channel'],
                                                    thumbnail:
                                                        video["thumbnail"],
                                                    publishDate:
                                                        video["publish_date"],
                                                    duration: video["duration"],
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
                                  ),
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
