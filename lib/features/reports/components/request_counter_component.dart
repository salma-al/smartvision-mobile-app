import 'package:flutter/material.dart';
import 'package:smart_vision/core/utils/media_query_values.dart';

class RequestCounterComponent extends StatelessWidget {
  final String status;
  final int count;
  final Color color;
  const RequestCounterComponent({super.key, required this.status, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width * 0.2,
      child: Column(
        children: [
          const SizedBox(height: 4),
          Container(
            width: context.width,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: color,
            ),
            child: Text(
              status,
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: context.width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
              color: color,
            ),
            child: Text(
              count.toString(),
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}