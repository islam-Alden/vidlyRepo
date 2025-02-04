import 'package:flutter/material.dart';
import 'package:vidly/utils/reuesable_widgets/custom_text_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CustomText(text: "Home page "),);
  }
}