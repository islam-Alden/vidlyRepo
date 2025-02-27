import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vidly/constants/app_colors.dart';
import 'package:vidly/constants/app_icons.dart';
import 'package:vidly/constants/app_paths.dart';
import 'package:vidly/constants/app_strings.dart';
import 'package:vidly/controller/live_streams_controller.dart';
import 'package:get/get.dart';
import 'package:vidly/controller/youtube_video_palyer_controller.dart';
import 'package:vidly/utils/reuesable_widgets/custom_container.dart';
import 'package:vidly/utils/reuesable_widgets/custom_search_bar.dart';
import 'package:vidly/utils/reuesable_widgets/custom_text_widget.dart';
import 'package:vidly/utils/reuesable_widgets/video_details.dart';
import 'package:vidly/utils/reuesable_widgets/youtube_widget.dart';
import 'package:vidly/utils/screen_util.dart';
import 'package:vidly/view/home_page/home_page_widgets/filter_widget.dart';



class LiveStreamPage extends StatelessWidget {
  const LiveStreamPage({super.key});

  @override
  Widget build(BuildContext context) {
    final liveStreamsController = Get.put(LiveStreamsController());
    final youtubeController = Get.put(XYoutubePlayerController());
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
                onIconPressed: liveStreamsController.openFilterBottomSheetWidget,
              ),
            ),
            Container(
              width: screenUtil.scaleWidth(0.77),
              height: screenUtil.scaleHeight(0.06),
              child: Form(
                key: liveStreamsController.liveStreamFormKey,
                child: CustomSearchBar(
                    controller: textFieldController,
                    validator: liveStreamsController.validateSearchQuery,
                    onChanged: (value) => liveStreamsController.searchQuery.value =
                        value // Update GetX variable
                    ,
                    prefixIcon: AppIcons.I_linkIcon,
                    textFieldLabel: AppStrings.S_videosSearchBarLabel,
                    textFieldHint: AppStrings.S_videosSearchBarHint,
                    suffixIcon: AppIcons.I_arrowForward,
                    onSuffixIconPressed: liveStreamsController.onValidate),
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
          if (liveStreamsController.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(

              children: [
                Obx(() {
                  return
                      Container(
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
                                         text: liveStreamsController.videoTitle.value.isNotEmpty 
                ? liveStreamsController.videoTitle.value 
                : "No Title Available", ),

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
                      padding: const EdgeInsets.all(6.0),
                      child: Obx(() {
                        if (liveStreamsController.isLoading.value) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (liveStreamsController.videosList.isEmpty) {
                          return Center(child: CustomText(text:"No videos found.", color: AppColors.C_purple,));
                        }
                        return ListView.builder(
                            itemCount: liveStreamsController.videosList.length,
                            itemBuilder: (context, index) {
                              var video = liveStreamsController.videosList[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomContainer(
                                    width: screenUtil.scaleWidth(0.58),
                                    height: screenUtil.scaleHeight(0.14),
                                    child: VideoDetailsWidget(
                                      imagePath: video["thumbnail"],
                                      videoTitle: video['title'],
                                      channelName: video['channel'],
                                      copy: AppStrings.S_copy,
                                      onCopyButtonPressed: () {
                                        Clipboard.setData(ClipboardData(text: video["live_link"]));
                                        Get.snackbar(
                                          "Copied!",
                                          "Copied to clipboard.",
                                          snackPosition: SnackPosition.TOP, // Shows snackbar at the bottom
                                          backgroundColor: Colors.green,
                                          colorText: Colors.white,
                                          duration: Duration(seconds: 2),
                                        );
                      
                                      }, onThumbnailPressed: () { 
                                        youtubeController.changeVideo("https://youtu.be/${video["video_id"]}");
                                      
                                        liveStreamsController.videoTitle.value = video['title'];
                                    },
                      
                                    )),
                              );
                                             
                            });
                      }),
                    ))
              ],
            );
          }
        }),
      ],
    );
  }
}
