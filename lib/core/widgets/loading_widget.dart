import 'package:flutter/material.dart';

import '../utils/media_query_values.dart';
import '../utils/colors.dart';

class LoadingWidget extends StatelessWidget {
  final double? progress;
  const LoadingWidget({super.key, this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withValues(alpha: 0.5),
      width: context.width,
      height: context.height,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: progress,
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
            if(progress != null)
            ...[
              const SizedBox(height: 12),
              Text('${(progress! * 100).toStringAsFixed(0)} %', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
            ],
          ],
        ),
      ),
    );
  }
}