import 'package:flutter/material.dart';
import 'package:vidly/utils/reuesable_widgets/custom_text_widget.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CustomText(text: "NO FAV VIDEOS YET"),);
  }
}