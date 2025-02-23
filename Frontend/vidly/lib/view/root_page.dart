import 'package:flutter/material.dart';
import 'package:vidly/constants/app_colors.dart';
import 'package:vidly/constants/app_paths.dart';
import 'package:vidly/constants/app_strings.dart';
import 'package:vidly/controller/bottm_navbar_controller.dart';
import 'package:vidly/utils/reuesable_widgets/bottom_nav_button.dart';
import 'package:vidly/utils/reuesable_widgets/custom_container.dart';
import 'package:vidly/utils/reuesable_widgets/gradient_bg.dart';
import 'package:vidly/utils/screen_util.dart';
import 'package:get/get.dart';
import 'package:vidly/view/home_page/home_page.dart';
import 'package:vidly/view/sub_pages/analysis/analysis_page.dart';
import 'package:vidly/view/sub_pages/favorite//favorite_page.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ScreenUtil screenUtil = ScreenUtil(context);
    final BottomNavbarController bottomNavbarController =
        Get.put(BottomNavbarController());

    final screens = [HomePage(), AnalysisPage(),FavoritePage() ];

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Expanded(
                  child: SizedBox(
                                  width: screenUtil.width,
                  height: screenUtil.scaleHeight(0.87),
                    child: Obx(() => screens[bottomNavbarController.currentPage.value])),
                ),
                    Obx(
            () => CustomContainer(
                width: screenUtil.scaleWidth(0.95),
                height: screenUtil.scaleHeight(0.08),
                borderRadius: 12,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BottomNavButton(
                          label: AppStrings.S_analysisNavButton,
                          iconPath: AppPaths.P_analysisIcon,
                          OnNavButtonPressed: () =>
                              bottomNavbarController.changePage(1),
                          textAndIconColor:
                              bottomNavbarController.currentPage.value == 1
                                  ? AppColors.C_deepPurple
                                  : AppColors.C_deepGrey),

                      BottomNavButton(
                          label: AppStrings.S_homeNavButton,
                          iconPath: AppPaths.P_homeIcon,
                          OnNavButtonPressed: () =>
                              bottomNavbarController.changePage(0),
                          textAndIconColor:
                              bottomNavbarController.currentPage.value == 0
                                  ? AppColors.C_deepPurple
                                  : AppColors.C_deepGrey),

                                                        BottomNavButton(
                          label: AppStrings.S_favoriteOutlineNavButton,
                          iconPath: AppPaths.P_favoriteOutlineIcon,
                          OnNavButtonPressed: () =>
                              bottomNavbarController.changePage(2),
                          textAndIconColor:
                              bottomNavbarController.currentPage.value == 2
                                  ? AppColors.C_deepPurple
                                  : AppColors.C_deepGrey),
                    ],
                  ),
                )),
                    )
              ],
            ),
          ),
        ),

        );
  }
}
