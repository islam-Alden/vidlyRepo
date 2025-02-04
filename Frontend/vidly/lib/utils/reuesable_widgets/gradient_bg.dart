import 'package:flutter/material.dart';
import 'package:vidly/constants/app_colors.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.C_darkPurple_level_2,AppColors.C_darkPurple_level_3],
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: child, // The actual screen content goes here
      ),
    );
  }
}
