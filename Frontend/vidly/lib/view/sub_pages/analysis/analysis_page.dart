import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vidly/constants/app_colors.dart';
import 'package:vidly/constants/app_icons.dart';
import 'package:vidly/constants/app_strings.dart';
import 'package:vidly/controller/analysis_controller.dart';
import 'package:vidly/controller/youtube_url_controller.dart';
import 'package:vidly/utils/reuesable_widgets/custom_container.dart';
import 'package:vidly/utils/reuesable_widgets/custom_search_bar.dart';
import 'package:vidly/utils/reuesable_widgets/custom_text_widget.dart';
import 'package:vidly/utils/reuesable_widgets/gradient_bg.dart';
import 'package:vidly/utils/reuesable_widgets/youtube_widget.dart';
import 'package:vidly/utils/screen_util.dart';
import 'package:vidly/view/sub_pages/analysis/analysis_widgets/analysis_chart_widget.dart';
import 'package:vidly/view/sub_pages/analysis/analysis_widgets/pie_chart_details.dart';


class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ScreenUtil screenUtil = ScreenUtil(context);

    // Initialize controllers
    final analysisController = Get.put(AnalysisController());
    final searchBarController = Get.put(AnalysisSearchBarController());
    final textFieldController = TextEditingController();

    return Scaffold(
      body: GradientBackground(
          child: Column(
            children: [
              SizedBox(
                height: 19,
              ),
              Form(
                key: searchBarController.formKey,
                child: CustomSearchBar(
                  controller: textFieldController,
                  validator: searchBarController.validateUserInput,
                  prefixIcon: AppIcons.I_linkIcon,
                  textFieldLabel: AppStrings.S_analysisTextFiledLabel,
                  textFieldHint: AppStrings.S_analysisTextFiledHint,
                  suffixIcon: AppIcons.I_arrowForward,
                  onSuffixIconPressed: searchBarController.onValidate
          
                ),
              ),
              SizedBox(
                height: 28,
              ),
              CustomYoutubePlayer(
                'https://youtu.be/2pgO8-nmgfE',
                width: screenUtil.scaleWidth(0.95),
                height: screenUtil.scaleHeight(0.23),
              ),
              SizedBox(
                height: 28,
              ),
              Obx((){
                          if(analysisController.isLoading.value){
                    return Center(child: CircularProgressIndicator(),);
                  }else{
                return Column(
                  children: [
                    Obx(() {
                      return analysisController.fetchedVideoTitle.value.isNotEmpty ? Container(
                        alignment: Alignment.topCenter,
                        // color:Colors.black38,
                        width: screenUtil.scaleWidth(0.95),
                        height: screenUtil.scaleHeight(0.05),
                        child: CustomText(
                            fontSize: screenUtil.aspectRatio * 42,
                            color: AppColors.C_purple,
                            textAlign: TextAlign.center,
                            enableScrolling: true,
                            text: analysisController.fetchedVideoTitle.value),
                      ): SizedBox(height: screenUtil.scaleHeight(0.05),);
                    }),
          
                                CustomContainer(
                width: screenUtil.scaleWidth(0.95),
                height: screenUtil.scaleHeight(0.39),
                child:
           Column(
                  children: [
                    Obx(() {
                      return AnalysisChartWidget(
                        totalComments: analysisController.totalComments.value,
                        positiveComments:
                            analysisController.positiveComments.value,
                        neutralComments: analysisController.neutralComments.value,
                        negativeComments:
                            analysisController.negativeComments.value, width: screenUtil.scaleWidth(0.58), height: screenUtil.scaleHeight(0.27),
                      );
                    }),
                    SizedBox(
                      height: 7,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Display PieChartDetails for each category
                          Obx(() => PieChartDetails(
                                categoryTitle: AppStrings.C_positiveCategory,
                                categoryColor: AppColors.C_deepPurple_level_1,
                                categoryTotalComments:
                                    analysisController.positiveComments.value,
                                categoryPercentage:
                                    analysisController.positivePercentage,
                              )),
                          Obx(() => PieChartDetails(
                                categoryTitle: AppStrings.C_neutralCategory,
                                categoryColor: AppColors.C_lightBlue,
                                categoryTotalComments:
                                    analysisController.neutralComments.value,
                                categoryPercentage:
                                    analysisController.neutralPercentage,
                              )),
          
                          Obx(() => PieChartDetails(
                                categoryTitle: AppStrings.C_negativeCategory,
                                categoryColor: AppColors.C_fuchsia,
                                categoryTotalComments:
                                    analysisController.negativeComments.value,
                                categoryPercentage:
                                    analysisController.negativePercentage,
                              )),
                        ],
                      ),
                    ),
                  ],
          
               
           ))
                  ],
                );}
            }),
          
          
              SizedBox(
                height: 10,
              ),
          
            ],
          )),
    );
  }
}
