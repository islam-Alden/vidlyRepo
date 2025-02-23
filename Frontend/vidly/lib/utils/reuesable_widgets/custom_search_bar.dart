import 'package:flutter/material.dart';
import 'package:vidly/constants/app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?) validator;
  final String Function(String)? onChanged;
  final IconData prefixIcon;
  final IconData suffixIcon;
  final String textFieldLabel;
  final String textFieldHint;

  final VoidCallback onSuffixIconPressed;

  CustomSearchBar({
    super.key,
    required this.controller,
    required this.validator,
    required this.prefixIcon,
    required this.textFieldLabel,
    required this.textFieldHint,
    required this.suffixIcon,
    required this.onSuffixIconPressed,
  this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        color: AppColors.C_deepPurple,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            vertical: 20, horizontal: 16), // Adjust padding as needed

        labelText: textFieldLabel,
        hintText: textFieldHint,
        labelStyle: TextStyle(color: AppColors.C_lightPurple),
        hintStyle: TextStyle(color: AppColors.C_lightPurple),
        prefixIcon: Icon(
          prefixIcon,
          color: AppColors.C_deepPurple,
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: GestureDetector(
            onTap: onSuffixIconPressed,
            child: Icon(
              suffixIcon,
              size: 34,
              color: AppColors.C_deepPurple,
            ),
          ),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.C_deepPurple)),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.C_deepPurple, width: 2.0),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.C_deepPurple),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.C_red),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.C_red),
        ),
      ),
      controller: controller,
      validator: validator,
      onChanged: onChanged,
    );
  }
}
