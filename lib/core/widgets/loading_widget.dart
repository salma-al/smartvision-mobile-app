import 'package:flutter/material.dart';
import 'package:smart_vision/core/utils/media_query_values.dart';

import '../utils/colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.5),
      width: context.width,
      height: context.height,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.mainColor),
                strokeWidth: 4,
              ),
            ),
            Image.asset(
              'assets/images/home_logo.png',
              width: 40,
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}