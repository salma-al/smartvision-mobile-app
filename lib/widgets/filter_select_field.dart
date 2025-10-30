import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_constants.dart';

class FilterSelectField extends StatefulWidget {
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final String? leadingSvgAsset;
  final String? trailingSvgAsset; // small arrow svg
  final bool popupMatchScreenWidth;
  final double screenHorizontalPadding;

  const FilterSelectField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.leadingSvgAsset,
    this.trailingSvgAsset,
    this.popupMatchScreenWidth = false,
    this.screenHorizontalPadding = 16,
  });

  @override
  State<FilterSelectField> createState() => _FilterSelectFieldState();
}

class _FilterSelectFieldState extends State<FilterSelectField> {
  final LayerLink _link = LayerLink();
  OverlayEntry? _entry;

  void _togglePopup() {
    if (_entry != null) {
      _hide();
    } else {
      _show();
    }
  }

  void _show() {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final fieldSize = renderBox.size;
    final fieldPosition = renderBox.localToGlobal(Offset.zero);
    final screenWidth = MediaQuery.of(context).size.width;

    // Popup base width
    const popupMinWidth = 180.0;
    final usableScreenWidth = screenWidth - (widget.screenHorizontalPadding * 2);
    final desiredWidth = widget.popupMatchScreenWidth ? usableScreenWidth : fieldSize.width;
    final popupWidth = desiredWidth < popupMinWidth ? popupMinWidth : desiredWidth;

    // Compute available space to right edge
    final spaceRight = screenWidth - fieldPosition.dx - 8;
    // Compute available space to left edge
    final spaceLeft = fieldPosition.dx - 8;

    // Default alignment (under field)
    double dx = 0;
    double maxWidth = popupWidth;

    if (widget.popupMatchScreenWidth) {
      dx = -(fieldPosition.dx - widget.screenHorizontalPadding);
      maxWidth = usableScreenWidth;
    } else if (popupWidth > spaceRight) {
      // If overflow to right, try shifting left
      if (spaceRight < popupMinWidth && spaceLeft > spaceRight) {
        // Show left-aligned if more space on the left
        dx = -(popupWidth - fieldSize.width);
      } else {
        // Otherwise, just clamp to available right space
        maxWidth = spaceRight;
      }
    }

    // Ensure widths are valid
    maxWidth = maxWidth.clamp(popupMinWidth, screenWidth);

    _entry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(onTap: _hide, behavior: HitTestBehavior.opaque),
            ),
            CompositedTransformFollower(
              link: _link,
              showWhenUnlinked: false,
              targetAnchor: Alignment.bottomLeft,
              followerAnchor: Alignment.topLeft,
              offset: Offset(dx, 8),
              child: Material(
                color: Colors.transparent,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: popupMinWidth,
                    maxWidth: maxWidth,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
                      boxShadow: AppShadows.popupShadow,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final opt in widget.options)
                          _OptionTile(
                            label: opt,
                            selected: opt == widget.value,
                            onTap: () {
                              widget.onChanged(opt);
                              _hide();
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context, debugRequiredFor: widget)?.insert(_entry!);
  }


  void _hide() {
    _entry?.remove();
    _entry = null;
  }

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: InkWell(
        onTap: _togglePopup,
        borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
            boxShadow: AppShadows.defaultShadow,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.leadingSvgAsset != null) ...[
                SvgPicture.asset(widget.leadingSvgAsset!, width: 18, height: 18, color: AppColors.darkText),
                const SizedBox(width: 8),
              ],
              Text(widget.label, style: AppTypography.helperText()),
              const SizedBox(width: 8),
              Text(widget.value, style: AppTypography.body14()),
              const SizedBox(width: 8),
              if (widget.trailingSvgAsset != null)
                SvgPicture.asset(widget.trailingSvgAsset!, width: 14, height: 14, color: AppColors.darkText)
              else
                const Icon(Icons.expand_more, size: 16, color: AppColors.darkText),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _OptionTile({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFEFEDED) : Colors.transparent,
            borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
          ),
          child: Text(label, style: AppTypography.p14()),
        ),
      ),
    );
  }
}


