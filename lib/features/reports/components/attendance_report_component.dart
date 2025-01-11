import 'package:flutter/material.dart';

import '../../../core/utils/colors.dart';

class AttendanceReportComponent extends StatelessWidget {
  final bool isFirst, isLast;
  final String type, date, status;
  final Color color;
  const AttendanceReportComponent({super.key, required this.isFirst, required this.isLast, required this.type, required this.date, required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: isFirst
            ? const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
            : isLast
                ? const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12))
                : null,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Main Details Column
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(top: 24, left: 18, bottom: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row with Type
                    RichText(
                      text: TextSpan(
                        text: 'Type: ',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.mainColor,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: type,
                            style: TextStyle(
                              color: AppColors.darkColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // From and To dates in a single row
                    RichText(
                      text: TextSpan(
                        text: 'Date: ',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.mainColor,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: date,
                            style: TextStyle(
                              color: AppColors.darkColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Status Container
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: isFirst ? const BorderRadius.only(topRight: Radius.circular(12)) : isLast ? const BorderRadius.only(bottomRight: Radius.circular(12)) : null,
                color: color,
              ),
              child: RotatedBox(
                quarterTurns: 3,
                child: Text(
                  status,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}