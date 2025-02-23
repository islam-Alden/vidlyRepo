import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vidly/constants/app_colors.dart';
import 'package:vidly/controller/pageview_controller.dart';
import 'package:get/get.dart';
import 'package:vidly/utils/helpers/scroll_controller.dart';
import 'package:vidly/view/home_page/home_subpages/live_stream_page.dart';
import 'package:vidly/view/home_page/home_subpages/playlist_page.dart';
import 'package:vidly/view/home_page/home_subpages/videos_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final pageViewController = Get.put(PageViewController());
    final myCustomScrollBehavior = MyCustomScrollBehavior();

    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: pageViewController.pageController,
            onPageChanged: pageViewController.onPageChanged,
            scrollBehavior: myCustomScrollBehavior,
            children: [
          VideosPage(),
                 LiveStreamPage(),
                 PlaylistPage()
          
            ],
          ),
        ),

          Container(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(pageViewController.pageTitles.length, (index) {
                return GestureDetector(
                  onTap: () => pageViewController.goToPage(index),
                  child: Obx(() {
                    // Check if the current page is this index
                    final bool isActive = pageViewController.currentPage.value == index;
                    return Text(
                      pageViewController.pageTitles[index],
                      style: TextStyle(
                        color: isActive ? AppColors.C_purple : Colors.grey,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        fontSize: 16,
                      ),
                    );
                  }),
                );
              }),
            ),
          ),
        ],
 
    );
  }
}
