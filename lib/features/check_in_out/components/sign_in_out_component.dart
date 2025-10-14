import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_vision/core/utils/colors.dart';
import 'package:smart_vision/core/utils/media_query_values.dart';

class SignInOutComponent extends StatelessWidget {
  final String title, value;
  const SignInOutComponent({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.mainColor,
              ),
              maxLines: 1,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: context.width * 0.4,
            child: Text(
              value,
              maxLines: 2,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.darkColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}