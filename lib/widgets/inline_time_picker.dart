import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InlineTimePicker {
  OverlayEntry? _overlayEntry;

  void show({
    required BuildContext context,
    required RenderBox renderBox,
    required TimeOfDay initialTime,
    required Function(TimeOfDay) onTimeSelected,
  }) {
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // TAP OUTSIDE TO CLOSE
            GestureDetector(
              onTap: hide,
              child: Container(
                color: Colors.transparent,
              ),
            ),

            // PICKER CONTAINER
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height + 6,
              width: size.width,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 180,
                  padding: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CupertinoTimerPicker(
                    mode: CupertinoTimerPickerMode.hm,
                    initialTimerDuration: Duration(
                      hours: initialTime.hour,
                      minutes: initialTime.minute,
                    ),
                    onTimerDurationChanged: (duration) {
                      final newTime = TimeOfDay(
                        hour: duration.inHours,
                        minute: duration.inMinutes % 60,
                      );
                      onTimeSelected(newTime);
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
