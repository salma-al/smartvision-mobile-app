import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'inline_date_picker.dart';
import '../constants/app_constants.dart';
import 'form_label.dart';
import 'filter_select_field.dart';

class FilterPanel extends StatefulWidget {
  final String? pageTitle; // e.g. "Request Approval"
  final String? pageSubtitle; // e.g. "View and filter your requests"
  final String typeLabel; // e.g. "Leave Type"
  final List<String> typeOptions;
  final List<String>? statusOptions;
  final bool showNeedActionCheckbox;
  final Function(String from, String to, String type, String status, bool needAction)? onFilter;

  const FilterPanel({
    super.key,
    this.pageTitle,
    this.pageSubtitle,
    required this.typeLabel,
    required this.typeOptions,
    this.statusOptions,
    this.showNeedActionCheckbox = false,
    this.onFilter,
  });

  @override
  State<FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
  bool _showFilters = false;
  DateTime? _fromDate;
  DateTime? _toDate;
  String _selectedType = '';
  String _selectedStatus = '';
  bool _needAction = true;

  @override
  void initState() {
    super.initState();

    if(widget.typeOptions.isNotEmpty) _selectedType = widget.typeOptions.first;
    _selectedStatus = widget.statusOptions?.first ?? '';

    final now = DateTime.now();
    _fromDate = DateTime(now.year, now.month, 1);
    _toDate = now;
  }

  Widget _buildFilterButton() {
    return GestureDetector(
      onTap: () => setState(() => _showFilters = !_showFilters),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: _showFilters ? const Color(0xFFE6E3E3) : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppShadows.popupShadow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
             SvgPicture.asset(
              'assets/images/filter.svg',
              width: 14,
              height: 14,
            ),
            const SizedBox(width: 6),
            Text('Filters', style: AppTypography.p14()),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey fromDateKey = GlobalKey();
    final GlobalKey toDateKey = GlobalKey();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and button in the same row (if title is provided)
        if (widget.pageTitle != null || widget.pageSubtitle != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.pageTitle != null)
                      Text(widget.pageTitle!, style: AppTypography.p16()),
                    if (widget.pageTitle != null && widget.pageSubtitle != null)
                      const SizedBox(height: 4),
                    if (widget.pageSubtitle != null)
                      Text(
                        widget.pageSubtitle!,
                        style: AppTypography.helperTextSmall(),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _buildFilterButton(),
            ],
          ),
          const SizedBox(height: 16),
        ] else ...[
          // If no title, just show button aligned to the right
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildFilterButton(),
            ],
          ),
          const SizedBox(height: 16),
        ],
        // 🔽 Filters section (visible when active)
        if (_showFilters)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE6E3E3),
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
                GestureDetector(
                  key: fromDateKey,
                  onTap: () {
                    InlineDatePicker.show(
                      context: context,
                      fieldKey: fromDateKey,
                      initialDate: _fromDate!,
                      onDateSelected: (date) => setState(() => _fromDate = date),
                      horizontalPadding: 32,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _fromDate != null
                              ? '${_fromDate!.day.toString().padLeft(2, '0')}/${_fromDate!.month.toString().padLeft(2, '0')}/${_fromDate!.year}'
                              : 'Select date',
                          style: AppTypography.p14(
                              color: _fromDate != null ? AppColors.darkText : AppColors.lightText),
                        ),
                        const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.darkText),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // To Date
                const FormLabel('To Date'),
                const SizedBox(height: 8),
                GestureDetector(
                  key: toDateKey,
                  onTap: () {
                    InlineDatePicker.show(
                      context: context,
                      fieldKey: toDateKey,
                      initialDate: _toDate ?? DateTime.now(),
                      onDateSelected: (date) => setState(() {
                        if (_fromDate != null && date.isBefore(_fromDate!)) {
                          _toDate = _fromDate;
                        } else {
                          _toDate = date;
                        }
                      }),
                      horizontalPadding: 32,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _toDate != null
                              ? '${_toDate!.day.toString().padLeft(2, '0')}/${_toDate!.month.toString().padLeft(2, '0')}/${_toDate!.year}'
                              : 'Select date',
                          style: AppTypography.p14(
                              color: _toDate != null ? AppColors.darkText : AppColors.lightText),
                        ),
                        const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.darkText),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Type filter
                if(widget.typeOptions.isNotEmpty)
                ...[
                  FormLabel(widget.typeLabel),
                  const SizedBox(height: 8),
                  FilterSelectField(
                    label: '',
                    value: _selectedType,
                    options: widget.typeOptions,
                    onChanged: (v) => setState(() => _selectedType = v),
                    popupMatchScreenWidth: true,
                    screenHorizontalPadding: 32,
                    backgroundColor: const Color(0xFFF6F6F6),
                  ),
                ],
                // Status filter (if statusOptions provided)
                if (widget.statusOptions != null) ...[
                  const SizedBox(height: 16),
                  const FormLabel('Status'),
                  const SizedBox(height: 8),
                  FilterSelectField(
                    label: '',
                    value: _selectedStatus,
                    options: widget.statusOptions!,
                    onChanged: (v) => setState(() => _selectedStatus = v),
                    popupMatchScreenWidth: true,
                    screenHorizontalPadding: 32,
                    backgroundColor: const Color(0xFFF6F6F6),
                  ),
                ],

                // Need Action checkbox (if enabled)
                if (widget.showNeedActionCheckbox) ...[
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: () => setState(() => _needAction = !_needAction),
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: _needAction ? AppColors.darkText : AppColors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: _needAction ? AppColors.darkText : AppColors.lightText,
                              width: 2,
                            ),
                          ),
                          child: _needAction
                              ? const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: AppColors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Text('Need Action', style: AppTypography.p14()),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        widget.onFilter!(
                          _fromDate == null ? '' : '${_fromDate!.year}-${_fromDate!.month.toString().padLeft(2, '0')}-${_fromDate!.day.toString().padLeft(2, '0')}',
                          _toDate == null ? '' : '${_toDate!.year}-${_toDate!.month.toString().padLeft(2, '0')}-${_toDate!.day.toString().padLeft(2, '0')}',
                          _selectedType,
                          _selectedStatus,
                          _needAction,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: _showFilters ? const Color(0xFFE6E3E3) : AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: AppShadows.popupShadow,
                        ),
                        child: Text('Apply', style: AppTypography.p14()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}