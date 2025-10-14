import 'package:flutter/material.dart';
import 'package:smart_vision/core/utils/media_query_values.dart';

import '../../../core/utils/colors.dart';
import 'sign_in_out_component.dart';

class CheckTimesCard extends StatelessWidget {
  final String inTime, outTime, hours;
  const CheckTimesCard({super.key, required this.inTime, required this.outTime, required this.hours});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SignInOutComponent(
            title: 'Check In Time',
            value: inTime,
          ),
          SignInOutComponent(
            title: 'Check Out Time',
            value: outTime,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Working Hours: ',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              SizedBox(
                width: context.width * 0.4,
                child: Text(
                  hours,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.darkColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}