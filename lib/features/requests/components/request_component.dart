import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
// import 'package:intl/intl.dart';

import '../../../core/helper/data_helper.dart';
import '../../../core/utils/colors.dart';
import '../model/request_model.dart';

class RequestComponent extends StatelessWidget {
  final RequestModel request;
  final Function(String) onApprove;
  final Function(String) onReject;

  const RequestComponent({
    super.key,
    required this.request,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    // final dateFormat = DateFormat('dd MMM yyyy');
    final instance = DataHelper.instance;
    final bool waitManager = request.status.toLowerCase() == 'requested';
    final bool waitHr = request.status.toLowerCase() == 'manager approved';
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Employee name and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    request.employeeName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.mainColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(request.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    request.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Request type
            Text(
              'Type: ${request.requestType}',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.darkColor,
              ),
            ),
            const SizedBox(height: 8),
            
            // Dates
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: AppColors.darkColor),
                const SizedBox(width: 4),
                Text(
                  request.endDate != null
                      ? '${request.startDate} - ${request.endDate!}'
                      : request.startDate,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.darkColor,
                  ),
                ),
              ],
            ),

            // Duration if available
            if (request.duration != null) ...[  
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: AppColors.darkColor),
                  const SizedBox(width: 4),
                  Text(
                    '${request.duration!} h',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.darkColor,
                    ),
                  ),
                ],
              ),
            ],
            
            // Reason if available
            if (request.reason != null) ...[  
              const SizedBox(height: 8),
              Text(
                'Reason: ${request.reason}',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.darkColor,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            
            // Action buttons for pending requests
            if ((instance.isHr && waitHr) || (instance.isManager && waitManager)) ...[  
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => onReject(request.id),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Reject'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => onApprove(request.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Approve'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'requested':
        return HexColor('#00b0ed');
      case 'manager approved':
        return HexColor('#00b0af');
      case 'approved':
        return HexColor('#63ea73');
      case 'rejected':
        return HexColor('#ff0000');
      case 'cancelled':
        return HexColor('#db8200');
      default:
        return Colors.transparent;
    }
  }
}