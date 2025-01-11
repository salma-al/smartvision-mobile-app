import 'package:flutter/material.dart';

import '../../../core/utils/colors.dart';

class RequestCardComponent extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius, statusBorderRadius;
  final String type, status, fromDate, toDate, reason;
  final Color statusColor;

  const RequestCardComponent({
    super.key, 
    this.borderRadius, 
    this.statusBorderRadius, 
    required this.type, 
    required this.status, 
    required this.fromDate, 
    required this.toDate, 
    required this.reason, 
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: borderRadius,
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
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: 'From: ',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.mainColor,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: fromDate,
                                  style: TextStyle(
                                    color: AppColors.darkColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: 'To: ',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.mainColor,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: toDate,
                                  style: TextStyle(
                                    color: AppColors.darkColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Reason (only for LeaveRequestsModel)
                    if (reason.isNotEmpty)
                      RichText(
                        text: TextSpan(
                          text: 'Reason: ',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.mainColor,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: reason,
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
                borderRadius: statusBorderRadius,
                color: statusColor,
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