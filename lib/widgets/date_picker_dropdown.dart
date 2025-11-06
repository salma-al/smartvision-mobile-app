import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class DatePickerDropdown extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime?) onDateSelected;
  final String placeholder;
  final Color? backgroundColor;

  const DatePickerDropdown({
    super.key,
    this.selectedDate,
    required this.onDateSelected,
    this.placeholder = 'Select date',
    this.backgroundColor,
  });

  @override
  State<DatePickerDropdown> createState() => _DatePickerDropdownState();
}

class _DatePickerDropdownState extends State<DatePickerDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  String _formatDate(DateTime? d) =>
      d != null ? '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}' : widget.placeholder;

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isOpen = false);
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    
    // Get screen height to check if calendar will be cut off
    final screenHeight = MediaQuery.of(context).size.height;
    const calendarHeight = 360.0;
    final spaceBelow = screenHeight - offset.dy - size.height;
    final spaceAbove = offset.dy;
    
    // Determine if calendar should show above or below the field
    final showAbove = spaceBelow < calendarHeight && spaceAbove > spaceBelow;
    final verticalOffset = showAbove ? -(calendarHeight + 4) : size.height + 4;

    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _closeDropdown,
        child: Stack(
          children: [
            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, verticalOffset),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: showAbove 
                          ? spaceAbove - 8 
                          : (spaceBelow < calendarHeight ? spaceBelow - 8 : calendarHeight),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: AppShadows.popupShadow,
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: AppColors.teal,
                          onPrimary: Colors.white,
                          onSurface: AppColors.darkText,
                        ),
                      ),
                      child: CalendarDatePicker(
                        initialDate: widget.selectedDate ?? DateTime.now(),
                        firstDate: DateTime(DateTime.now().year - 1),
                        lastDate: DateTime(DateTime.now().year + 2),
                        onDateChanged: (date) {
                          widget.onDateSelected(date);
                          _closeDropdown();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _closeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPlaceholder = widget.selectedDate == null;
    
    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
        onTap: _toggleDropdown,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? const Color(0xFFF6F6F6),
            borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(widget.selectedDate),
                style: AppTypography.p14(
                  color: isPlaceholder ? AppColors.lightText : AppColors.darkText,
                ),
              ),
              const Icon(Icons.calendar_today_outlined,
                  size: 16, color: AppColors.darkText),
            ],
          ),
        ),
      ),
    );
  }
}

