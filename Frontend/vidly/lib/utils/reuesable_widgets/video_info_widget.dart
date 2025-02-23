import 'package:flutter/material.dart';
import 'package:vidly/utils/reuesable_widgets/custom_text_widget.dart';

import '../../constants/app_colors.dart';


class VideoInfoWidget extends StatelessWidget {
  final String iconPath;
  final String infoType;
  const VideoInfoWidget({super.key, required this.iconPath, required this.infoType});

  @override
  Widget build(BuildContext context) {
    return                           Container(
      padding: EdgeInsets.only(right: 8.0),
      height: 20,

      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(4.0),
            child: Image.asset(
              iconPath,
              fit: BoxFit.cover,
              color: AppColors.C_lightBlue,
            ),
          ),
          CustomText(text: infoType, color: AppColors.C_purple,fontSize: 14,)
        ],
      ),

    );
  }
}
