// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:vidly/TESTS/customSF.dart';
// import 'package:vidly/TESTS/customSFController.dart';
// import 'package:vidly/constants/app_icons.dart';
// import 'package:vidly/constants/app_strings.dart';
// import 'package:vidly/utils/reuesable_widgets/custom_text_widget.dart';
// import 'package:vidly/utils/reuesable_widgets/gradient_bg.dart';

// class SearchFieldValidation extends StatelessWidget {
//   const SearchFieldValidation({super.key});

//   @override
//   Widget build(BuildContext context) {
//     TextEditingController searchController = TextEditingController();
//     final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//     final Xcontroller = Get.put(SearchBarController());

//     return Scaffold(
//         body: GradientBackground(
//       child: Container(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Form(
//                 key: Xcontroller.formKey,
//                 child: CustomSearchBar(
//                   controller: searchController,
//                   validator: Xcontroller.validateUserInput,
//                   prefixIcon: AppIcons.I_linkIcon,
//                   textFieldLabel: AppStrings.S_analysisTextFiledLabel,
//                   textFieldHint: AppStrings.S_analysisTextFiledHint,
//                   suffixIcon: AppIcons.I_arrowForward, onSuffixIconPressed:Xcontroller.onValidate,
     
//                 ),
//               ),
//             ),
//             ElevatedButton(
//                 onPressed: () {
//                   Xcontroller.onValidate();
//                 },
//                 child: Text('Validate'))
//           ],
//         ),
//       ),
//     ));
//   }
// }
