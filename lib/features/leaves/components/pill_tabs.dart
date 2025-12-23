import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/helper/data_helper.dart';

class PillTabs extends StatelessWidget {
  final int index;
  final List<String> tabs;
  final ValueChanged<int> onChanged;

  const PillTabs({
    super.key,
    required this.index,
    required this.tabs,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final accent = DataHelper.instance.comp!.primaryColor;
    return Container(
      // padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(9999),
        boxShadow: AppShadows.defaultShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < tabs.length; i++)
            Padding(
              padding: EdgeInsets.only(left: i == 0 ? 0 : 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(9999),
                onTap: () => onChanged(i),
                child: Container(
                  width: 134,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: i == index ? accent : Colors.transparent,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Center(
                    child: Text(
                      tabs[i],
                      style: AppTypography.p14(color: i == index ? AppColors.white : AppColors.darkText),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}