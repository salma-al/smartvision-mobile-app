import 'package:flutter/material.dart';

import '../../../core/utils/media_query_values.dart';
import '../../../core/utils/colors.dart';

class CountComponent extends StatelessWidget {
  final List<String> counts;
  final Color Function(String) getTextColor;
  final int Function(String) getTextCount;
  final VoidCallback collapse;
  final bool collapsed;
  const CountComponent({super.key, required this.counts, required this.getTextColor, required this.getTextCount, required this.collapse, required this.collapsed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Count dashboard', style: TextStyle(color: AppColors.mainColor)),
            IconButton(
              onPressed: collapse, 
              icon: Icon(collapsed ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, color: AppColors.mainColor),
            ),
          ],
        ),
        if(!collapsed)
        Wrap(
          children: counts.map((status) => 
            SizedBox(
              width: context.width * 0.4,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          status, 
                          style: TextStyle(color: getTextColor(status)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${getTextCount(status)}',
                        style: TextStyle(color: getTextColor(status)),
                      ),
                    ],
                  ),
                ),
              ),
            )).toList(),
        ),
      ],
    );
  }
}