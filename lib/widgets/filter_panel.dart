import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_constants.dart';
import 'form_label.dart';
import 'filter_select_field.dart';

class FilterPanel extends StatefulWidget {
  final String typeLabel; // e.g. "Leave Type"
  final List<String> typeOptions;
  final Function(String from, String to, String type)? onFilter;

  const FilterPanel({
    super.key,
    required this.typeLabel,
    required this.typeOptions,
    this.onFilter,
  });

  @override
  State<FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
  bool _showFilters = false;
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();
  String _selectedType = '';

  @override
  void initState() {
    super.initState();
    _selectedType = widget.typeOptions.first;
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';

  Future<void> _pickDate(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? _fromDate : _toDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.teal,
              onPrimary: Colors.white,
              onSurface: AppColors.darkText,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
          if (_toDate.isBefore(_fromDate)) _toDate = _fromDate;
        } else {
          _toDate = picked.isBefore(_fromDate) ? _fromDate : picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔘 Filters button
        GestureDetector(
          onTap: () => setState(() => _showFilters = !_showFilters),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: _showFilters ? const Color(0xFFE6E3E3) : AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppShadows.popupShadow,
            ),
            child: Row(
              children: [
                 SvgPicture.asset(
                  'assets/icons/filter.svg',
                  width: 14,
                  height: 14,
                ),
                const SizedBox(width: 6),
                Text('Filters', style: AppTypography.p14()),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 🔽 Filters section (visible when active)
        if (_showFilters)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppShadows.popupShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Filter Options', style: AppTypography.p16()),
                const SizedBox(height: 16),

                // From Date
                const FormLabel('From Date'),
                const SizedBox(height: 8),
                _DateField(
                  label: _formatDate(_fromDate),
                  onTap: () => _pickDate(true),
                ),
                const SizedBox(height: 16),

                // To Date
                const FormLabel('To Date'),
                const SizedBox(height: 8),
                _DateField(
                  label: _formatDate(_toDate),
                  onTap: () => _pickDate(false),
                ),
                const SizedBox(height: 16),

                // Type filter
                FormLabel(widget.typeLabel),
                const SizedBox(height: 8),
                FilterSelectField(
                  label: '',
                  value: _selectedType,
                  options: widget.typeOptions,
                  onChanged: (v) => setState(() => _selectedType = v),
                  popupMatchScreenWidth: true,
                  screenHorizontalPadding: 0,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// 🔹 Simple DateField (same style as your page)
class _DateField extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
          boxShadow: AppShadows.popupShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.p14()),
            const Icon(Icons.calendar_today_outlined,
                size: 16, color: AppColors.darkText),
          ],
        ),
      ),
    );
  }
}
