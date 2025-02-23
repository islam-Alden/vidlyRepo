import 'package:flutter/material.dart';
import 'package:vidly/constants/app_colors.dart';

class CustomContainer extends StatelessWidget {
  final double width;
  final double? height;
  final double? borderRadius;
  final double? borderWidth;
  final Widget child;
  final Color? borderColor;
  final Color? backgroundColor;
  final double? paddingValue;
  const CustomContainer({
    Key? key,
    required this.width,
this.height,
    this.borderRadius,
    this.borderWidth,
    this.borderColor,
this.paddingValue,
    required this.child,
     this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Container(
    padding: EdgeInsets.all(paddingValue ?? 0),
      width: width,
      height: height,
  
      decoration: BoxDecoration(
        color:backgroundColor ?? AppColors.C_transparent,
        gradient: LinearGradient(
          colors: [AppColors.C_darkPurple_level_4,AppColors.C_lightPurple,],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),// Apply gradient
        borderRadius:BorderRadius.circular(borderRadius ?? 16.0)  , // Rounded corners
        border: Border.all(
          width: borderWidth ?? 1.0, // Border width
          color: borderColor ?? AppColors.C_deepPurple // Border color
        ),
      ),
      child: child,
    );
  }
}
