import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../helper/data_helper.dart';

class InlineDatePicker {
  static OverlayEntry? _overlay;

  static void show({
    required BuildContext context,
    required GlobalKey fieldKey,
    required DateTime initialDate,
    required Function(DateTime) onDateSelected,
    double horizontalPadding = AppSpacing.pagePaddingHorizontal,
  }) {
    final renderBox = fieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final fieldOffset = renderBox.localToGlobal(Offset.zero);
    final fieldSize = renderBox.size;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    const calendarHeight = 360.0;
    final spaceBelow = screenHeight - fieldOffset.dy - fieldSize.height;
    final spaceAbove = fieldOffset.dy;
    final showAbove = spaceBelow < calendarHeight && spaceAbove > spaceBelow;
    final topPosition = showAbove
        ? fieldOffset.dy - calendarHeight - 8
        : fieldOffset.dy + fieldSize.height + 8;
    final maxHeight = showAbove
        ? (spaceAbove - 16).clamp(200.0, calendarHeight)
        : (spaceBelow - 16).clamp(200.0, calendarHeight);

    final accentColor = DataHelper.instance.comp!.primaryColor;

    _overlay = OverlayEntry(
      builder: (context) => Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: hide,
              behavior: HitTestBehavior.opaque,
            ),
          ),
          Positioned(
            left: horizontalPadding,
            right: horizontalPadding,
            top: topPosition,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: screenWidth - horizontalPadding * 2,
                constraints: BoxConstraints(maxHeight: maxHeight),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
                  boxShadow: AppShadows.popupShadow,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
                  child: Material(
                    color: AppColors.white,
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: Theme(
                        data: ThemeData(
                          datePickerTheme: DatePickerThemeData(
                            dayOverlayColor: WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.selected)) return accentColor;
                              if (states.contains(WidgetState.hovered)) return accentColor.withValues(alpha: 0.1);
                              return null;
                            }),
                            dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.selected)) return accentColor;
                              return null;
                            }),
                            dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.selected)) return Colors.white;
                              return AppColors.darkText;
                            }),
                            todayForegroundColor: WidgetStateProperty.all(accentColor),
                            todayBackgroundColor: WidgetStateProperty.all(Colors.transparent),
                            yearForegroundColor: WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.selected)) return Colors.white;
                              return AppColors.darkText;
                            }),
                            yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.selected)) return accentColor;
                              return null;
                            }),
                          ),
                        ),
                        child: CalendarDatePicker(
                          initialDate: initialDate,
                          firstDate: DateTime(DateTime.now().year - 1),
                          lastDate: DateTime(DateTime.now().year + 2),
                          onDateChanged: (picked) {
                            onDateSelected(picked);
                            hide();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlay!);
  }

  static void hide() {
    _overlay?.remove();
    _overlay = null;
  }
}