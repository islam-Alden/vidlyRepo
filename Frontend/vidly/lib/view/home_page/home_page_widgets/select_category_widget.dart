import 'package:flutter/material.dart';
import 'package:vidly/constants/app_colors.dart';
import 'package:vidly/utils/helpers/category_id_map.dart';
import 'package:get/get.dart';

class CategoryBottomSheetWidget extends StatefulWidget {
  const CategoryBottomSheetWidget({super.key});

  @override
  State<CategoryBottomSheetWidget> createState() => _CategoryBottomSheetWidgetState();
}

class _CategoryBottomSheetWidgetState extends State<CategoryBottomSheetWidget> {

  // This map will keep track of which categories are selected.
  final Map<String, bool> _selectedCategories = {};

  @override
  void initState() {
    super.initState();
    // Initialize each category as not selected.
    categoryMap.keys.forEach((category) {
      _selectedCategories[category] = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      // Set the desired height for your bottom sheet.
      height: 400,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:AppColors.C_white ,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Text(
            'Select Categories',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Divider(),
          Expanded(
            child: ListView(
              children: _selectedCategories.keys.map((category) {
                return CheckboxListTile(
                  title: Text(category),
                  value: _selectedCategories[category],
                  onChanged: (bool? value) {
                    setState(() {
                      _selectedCategories[category] = value ?? false;
                    });
                  },
                );
              }).toList(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
                // Convert selected category names to their IDs.
              List<int> selectedCategoryIds = _selectedCategories.entries
                  .where((entry) => entry.value)
                  .map((entry) => categoryMap[entry.key]!)
                  .toList();

              Get.back(result: selectedCategoryIds);
            },
            child: Text("Apply"),
          ),
        ],
      ),
    );
  }
}