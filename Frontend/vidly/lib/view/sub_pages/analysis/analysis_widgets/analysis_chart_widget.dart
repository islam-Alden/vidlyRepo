import 'package:flutter/material.dart';
import 'package:d_chart/d_chart.dart';
import 'package:intl/intl.dart';
import 'package:vidly/constants/app_colors.dart';

class AnalysisChartWidget extends StatelessWidget {
  final int totalComments;
  final int positiveComments;
  final int neutralComments;
  final int negativeComments;
  final double width;
  final double height;


  AnalysisChartWidget(
      {super.key,
      required this.totalComments,
      required this.positiveComments,
      required this.neutralComments,
      required this.negativeComments, required this.width, required this.height});

  late List<OrdinalData> ordinalDataList = [
    OrdinalData(
      domain: 'Positive',
      measure: positiveComments,
      color: AppColors.C_deepPurple_level_1,
    ),
    OrdinalData(
      domain: 'Neutral',
      measure: neutralComments,
      color: AppColors.C_lightBlue,
    ),
    OrdinalData(
      domain: 'Negative',
      measure: negativeComments,
      color: AppColors.C_fuchsia,
    ),
  ];

  @override
  Widget build(BuildContext context) {

    
    return Column(
      children: [
        Container(

          width: width,
          height: height,
          child: Stack(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            children: [
              DChartPieO(
                data: ordinalDataList,
                customLabel: (ordinalData, index) {
                  return '${ordinalData.measure}%';
                },
                configRenderPie: const ConfigRenderPie(
                  strokeWidthPx: 0,
                  arcWidth: 20,
    
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      NumberFormat.decimalPatternDigits().format(totalComments),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 42,
                        color: AppColors.C_deepPurple_level_2,
                      ),
                    ),
                    const Text(
                      'Comments',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: AppColors.C_purple,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      
      ],
    );
  }
}
