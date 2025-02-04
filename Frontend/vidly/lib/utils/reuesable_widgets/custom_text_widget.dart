import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final String? fontFamily;
   final bool enableScrolling;


  const CustomText(
 {
    Key? key,
    required this.text,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.fontFamily,
     this.enableScrolling = false,
   
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final textStyle = TextStyle(
      fontSize: fontSize ?? 14, // Default size
      color: color ?? Colors.black, // Default color
      fontWeight: fontWeight ?? FontWeight.normal, // Default weight
      fontFamily: fontFamily, // Optional font family
    );


    return enableScrolling ? SizedBox(
            height: fontSize != null ? fontSize! + 10 : 18, // Adjust height for marquee
            child: Marquee(
               key: ValueKey(text),
              text: text,
              
              style: textStyle,
              blankSpace: 20.0,
              velocity: 50.0,
              startPadding: 10.0,
              scrollAxis: Axis.horizontal,
            ),
          ): Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      style:textStyle,
 
    );
  }
}
