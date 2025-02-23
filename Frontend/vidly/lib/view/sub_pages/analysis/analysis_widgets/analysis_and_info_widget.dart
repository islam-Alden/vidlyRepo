import 'package:flutter/material.dart';
import 'package:vidly/constants/app_strings.dart';
import 'package:vidly/utils/reuesable_widgets/custom_text_widget.dart';

class AnalysisAndInfoWidget extends StatelessWidget {


final double Width;
final double Height;

const AnalysisAndInfoWidget({
required this.Width, required this.Height,
});

  @override
  Widget build(BuildContext context) {
    return Container(
     
      padding: EdgeInsets.only(left: 6.0, right: 6.0),
      width: Width,
      height:Height,

      child:
        Column(
          children: [
            Stack(children: [
              CustomText(text: AppStrings.C_commentsTitle,textAlign: TextAlign.end,fontSize: 18,fontWeight: FontWeight.bold,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomText(text: AppStrings.C_totalFetchedComments,textAlign: TextAlign.end,fontSize: 62,fontWeight: FontWeight.bold,),
            )
            
                
                  
                  ],),
                  // AnalysisChartWidget(totalComments: 4000, positiveComments: 1000, naturalComments: 1200, negativeComments: 3000,)
          ],
        ));
  }
}

