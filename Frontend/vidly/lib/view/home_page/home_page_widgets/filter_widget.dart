import 'package:flutter/material.dart';

class FilterWidget extends StatelessWidget {
  final String iconPath;
  final VoidCallback onIconPressed;
  final Color? iconColor;
  const FilterWidget.FilterButton(
      {super.key,
      required this.iconPath,
      required this.onIconPressed,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GestureDetector(
          onTap: onIconPressed,
          child: Image.asset(
            iconPath,
            color: iconColor ?? Colors.black,
          )),
    );
  }
}
