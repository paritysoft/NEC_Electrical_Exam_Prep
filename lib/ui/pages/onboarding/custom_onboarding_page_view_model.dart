import 'package:flutter/material.dart';
import '../../../util/app_constants.dart';
import '../../widgets/common_widget.dart';

class CustomOnboardingPageViewModel extends StatelessWidget {
  const CustomOnboardingPageViewModel({
    Key? key,
    required this.imageUrl,
    required this.modelTitle,
    required this.modelDescription,
  }) : super(key: key);

  final String imageUrl, modelTitle, modelDescription;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: padding20 * 2),
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage(imageUrl),
      //     fit: BoxFit.fitHeight,
      //   ),
      // ),
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Container(
            alignment: Alignment.center, // use aligment
            color: Colors.white,
            child: Image.asset(
              imageUrl,
              alignment: Alignment.center,
              width: double.infinity,
              height: 200,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            margin: EdgeInsets.only(bottom: padding20 * 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                titleLabel(context, modelTitle, color: Colors.black),
                SizedBox(
                  height: padding20 / 2,
                ),
                smallLabel(context, modelDescription, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
