import 'package:flutter/material.dart';
import 'package:vidly/utils/reuesable_widgets/custom_text_widget.dart';

class BottomNavButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final Color textAndIconColor;
  final VoidCallback OnNavButtonPressed;

  const BottomNavButton(
      {super.key,
      required this.label,
      required this.iconPath,
      required this.OnNavButtonPressed,
      required this.textAndIconColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: OnNavButtonPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                // color: Colors.black38,
                width: 50,
                height: 45,
                child: Image.asset(
                  iconPath,
                  color: textAndIconColor,
                  fit: BoxFit.contain,
                )),
           CustomText(text: label,color: textAndIconColor,fontSize: 13,fontWeight: FontWeight.w400,)
          ],
        ),
      ),
    );
  }
}
