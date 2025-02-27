import 'package:flutter/material.dart';
import 'package:vidly/constants/app_paths.dart';
import 'package:vidly/constants/app_strings.dart';
import 'package:vidly/utils/reuesable_widgets/custom_container.dart';
import 'package:vidly/utils/reuesable_widgets/custom_text_widget.dart';
import 'package:vidly/utils/reuesable_widgets/video_info_widget.dart';
import 'package:vidly/utils/screen_util.dart';

import '../../constants/app_colors.dart';

class VideoDetailsWidget extends StatelessWidget {
  final String imagePath;
  final String? videoTitle;
  final String? channelName;
  final String? videoLength;
  final String? videoDate;
  final String copy;
  final VoidCallback onCopyButtonPressed;
  final VoidCallback onThumbnailPressed;
  final VoidCallback? onActionButtonPressed; 
final IconData? actionButtonIcon;

  const VideoDetailsWidget({
    super.key,
    required this.imagePath,
    this.videoTitle,
    this.channelName,
    this.videoLength,
    this.videoDate,
    required this.copy,
    required this.onCopyButtonPressed,
    required this.onThumbnailPressed, 
    this.onActionButtonPressed, 
    this.actionButtonIcon,
  });

  @override
  Widget build(BuildContext context) {
    final ScreenUtil screenUtil = ScreenUtil(context);
    return CustomContainer(
      paddingValue: 12.0,
      width: screenUtil.scaleWidth(0.85),
      height: screenUtil.scaleHeight(0.5),
      child: Row(
        children: [
          GestureDetector(
            child: ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
            onTap: onThumbnailPressed,
          ),
          Expanded(
            child: SizedBox(
              width: 120,
              height: 120,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: videoTitle ?? AppStrings.S_unknown,
                      fontSize: 16,
                      color: AppColors.C_purple,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        VideoInfoWidget(
                          iconPath: AppPaths.P_personIcon,
                          infoType: channelName ?? AppStrings.S_unknown,
                        ),
                        // Only show the add favorite button if onAddFavPressed is provided.
                        if (onActionButtonPressed != null)
                          GestureDetector(
                            child:Icon(actionButtonIcon, size: 28,color: AppColors.C_lightPurple,),
                          
                            onTap: onActionButtonPressed,
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        VideoInfoWidget(
                          iconPath: AppPaths.P_clockIcon,
                          infoType: videoLength ?? AppStrings.S_unknown,
                        ),
                        VideoInfoWidget(
                          iconPath: AppPaths.P_agendaIcon,
                          infoType: videoDate ?? AppStrings.S_unknown,
                        ),
                        GestureDetector(
                          child: VideoInfoWidget(
                            iconPath: AppPaths.P_copyIcon, 
                            infoType: copy,
                          ),
                          onTap: onCopyButtonPressed,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
