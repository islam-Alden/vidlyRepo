import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageViewController extends GetxController {
  // Reactive variable for current page
  var currentPage = 0.obs;

  // List of titles corresponding to each page
  final List<String> pageTitles = [
    'Videos',
    'Live stream',
    'Playlists ',
  ];

  // PageController for the PageView
  final PageController pageController = PageController();

  // Update the current page when the PageView scrolls
  void onPageChanged(int index) {
    currentPage.value = index;
  }

  // Navigate to the specified page when a title is tapped
  void goToPage(int index) {
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
