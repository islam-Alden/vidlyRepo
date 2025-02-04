import 'package:flutter/material.dart';
import 'package:vidly/constants/app_colors.dart';
import 'package:vidly/utils/reuesable_widgets/custom_container.dart';
import 'package:vidly/utils/reuesable_widgets/custom_text_widget.dart';
import 'package:vidly/utils/screen_util.dart';

class PieChartDetails extends StatelessWidget {
  final String categoryTitle;
  final Color? categoryColor;
  final int categoryTotalComments;
  final int categoryPercentage;

  const PieChartDetails(
      {super.key,
      required this.categoryTitle,
      this.categoryColor,
      required this.categoryTotalComments,
      required this.categoryPercentage});

  @override
  Widget build(BuildContext context) {
    final ScreenUtil screenUtil = ScreenUtil(context);
    return CustomContainer(
    width:screenUtil.scaleWidth(0.27), // Width of the container
    height: screenUtil.scaleHeight(0.06), 
      borderColor: categoryColor,
        borderRadius: 12,
        borderWidth: 1.5,
      child: Column(

        children: [
            CustomText(text: "$categoryTitle $categoryTotalComments",fontSize: 15,color: AppColors.C_purple,),

          CustomText(
            text: "$categoryPercentage %",
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.C_deepPurple_level_2,
          ),
        ],
      ),
    );
  }
}
