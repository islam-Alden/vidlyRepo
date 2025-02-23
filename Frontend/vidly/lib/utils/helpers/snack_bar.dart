import 'package:flutter/material.dart';
import 'package:get/get.dart';

customSnackBar(String title, String message, Color backgroundColor, Color textColor) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.TOP, // Shows snackbar at the bottom
    backgroundColor: backgroundColor,
    colorText: textColor,
    duration: Duration(seconds: 2),
  );
}
