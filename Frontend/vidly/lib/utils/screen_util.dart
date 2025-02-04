import 'package:flutter/material.dart';

/// A utility class to handle screen size calculations for responsive design.
/// This class provides methods to get screen dimensions, scale widget sizes,
/// and adjust font sizes based on the screen width.
class ScreenUtil {
  /// The BuildContext is required to access MediaQuery for screen dimensions.
  final BuildContext context;

  /// Constructor that takes a BuildContext to initialize the utility.
  ScreenUtil(this.context);

  /// Returns the width of the screen.
  /// Useful for setting widget widths relative to the screen size.
  double get width => MediaQuery.of(context).size.width;

  /// Returns the height of the screen.
  /// Useful for setting widget heights relative to the screen size.
  double get height => MediaQuery.of(context).size.height;

  /// Returns the aspect ratio of the screen (width divided by height).
  /// Can be used to adjust layouts or widgets based on the device's proportions.
  double get aspectRatio => width / height;

  /// Scales a width value by a given percentage of the total screen width.
  /// 
  /// Example:
  /// - If the screen width is 400 and percentage is 0.5, the result is 200.
  /// Use this to make widgets adapt dynamically to different screen sizes.
  double scaleWidth(double percentage) => width * percentage;

  /// Scales a height value by a given percentage of the total screen height.
  /// 
  /// Example:
  /// - If the screen height is 800 and percentage is 0.2, the result is 160.
  /// Use this to ensure widgets maintain relative proportions across screens.
  double scaleHeight(double percentage) => height * percentage;

  /// Scales a font size based on the screen width.
  /// This ensures that text sizes are proportional across devices of varying widths.
  /// 
  /// Example:
  /// - On a screen with width 375 (baseline), a font size of 16 will remain consistent.
  /// - On a larger screen, the font size will scale up accordingly.
  double scaleFont(double fontSize) => fontSize * (width / 375);
}
