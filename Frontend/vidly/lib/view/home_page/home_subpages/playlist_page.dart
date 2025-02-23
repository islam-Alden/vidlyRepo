import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vidly/constants/app_colors.dart';
import 'package:vidly/constants/app_icons.dart';
import 'package:vidly/constants/app_strings.dart';
import 'package:get/get.dart';
import 'package:vidly/controller/favorite_videos_controller.dart';
import 'package:vidly/controller/playlists_controller.dart';
import 'package:vidly/utils/helpers/snack_bar.dart';
import 'package:vidly/utils/reuesable_widgets/custom_container.dart';
import 'package:vidly/utils/reuesable_widgets/custom_search_bar.dart';
import 'package:vidly/utils/reuesable_widgets/custom_text_widget.dart';
import 'package:vidly/utils/reuesable_widgets/video_details.dart';
import 'package:vidly/utils/reuesable_widgets/youtube_widget.dart';
import 'package:vidly/utils/screen_util.dart';
import 'package:vidly/view/home_page/home_page_widgets/palylist_videos_widget.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {

    // Initialize controllers
    final playlistsController = Get.put(PlaylistsController());
    final ScreenUtil screenUtil = ScreenUtil(context);
final textFieldController = TextEditingController();

    return Column(
      children: [
        SizedBox(
          height: 19,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                width: screenUtil.scaleWidth(0.77),
                height: screenUtil.scaleHeight(0.06),
                child: Form(
                  key: playlistsController.playlistsFormKey,
                  child: CustomSearchBar(
                      controller: textFieldController,
                      validator: playlistsController.validateSearchQuery,
                      onChanged: (value) => playlistsController
                          .searchQuery.value = value // Update GetX variable
                      ,
                      prefixIcon: AppIcons.I_linkIcon,
                      textFieldLabel: AppStrings.S_videosSearchBarLabel,
                      textFieldHint: AppStrings.S_videosSearchBarHint,
                      suffixIcon: AppIcons.I_arrowForward,
                      onSuffixIconPressed: playlistsController.onValidate),
                ),
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
          if (playlistsController.isLoading.value) {
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
                          text: playlistsController.videoTitle.value.isNotEmpty
                              ? playlistsController.videoTitle.value
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
                          if (playlistsController.isLoading.value) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (playlistsController.videosList.isEmpty) {
                            return Center(
                                child: CustomText(
                              text: "No videos found.",
                              color: AppColors.C_purple,
                            ));
                          }

                          return ListView.builder(
                            itemCount: playlistsController.videosList.length,
                            itemBuilder: (context, index) {
                              var playlist =
                                  playlistsController.videosList[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomContainer(
                                  width: screenUtil.scaleWidth(0.55),
                                  height: screenUtil.scaleHeight(0.14),
                                  child: VideoDetailsWidget(
                                    imagePath: playlist["thumbnail"],
                                    videoTitle: playlist['title'],
                                    channelName: playlist['channel'],
                                    copy: AppStrings.S_copy,
                                    onCopyButtonPressed: () {
                                      Clipboard.setData(
                                        ClipboardData(
                                            text: playlist["playlist_id"]),
                                      );
                                      customSnackBar(
                                          "Copied!",
                                          "Copied to clipboard.",
                                          AppColors.C_green,
                                          AppColors.C_white);
                                    },
                                    onThumbnailPressed: () {
                                      playlistsController.videoTitle.value =
                                          playlist['title'];

                                      // Open the bottom sheet with an expandable (draggable) mechanism.
                                      Get.bottomSheet(
                                        PlaylistVideosBottomSheet(
                                          playlistId: playlist["playlist_id"],
                                        ),
                                        // Set backgroundColor to transparent to show rounded corners.
                                        backgroundColor: Colors.transparent,
                                        isScrollControlled: true,
                                      );
                                    },

                                  ),
                                ),
                              );
                            },
                          );
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
