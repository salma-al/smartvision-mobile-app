import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomDropdownFormField<T> extends StatelessWidget {
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder, enabledBorder;
  final TextStyle? textStyle, hintStyle;
  final Color? fillColor;
  final T? value;
  final List<DropdownMenuItem<T>>? items;
  final String hintText;
  final Widget? prefixIcon, suffixIcon;
  final void Function(T?)? onChanged;
  final bool? isDense;
  final double? raduis;

  const CustomDropdownFormField({
    super.key,
    this.contentPadding,
    this.focusedBorder,
    this.enabledBorder,
    this.textStyle,
    this.hintStyle,
    this.fillColor,
    this.value,
    this.items,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.isDense,
    this.raduis,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: fillColor ?? Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(raduis ?? 16),
        border: Border.all(
          color: enabledBorder != null
              ? enabledBorder!.borderSide.color
              : const Color.fromRGBO(237, 237, 237, 1),
          width: 1.3,
        ),
      ),
      child: DropdownButtonFormField<T>(
        value: value,
        items: items,
        isDense: isDense ?? true,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          focusedBorder: focusedBorder ??
              OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent, width: 1.3),
                borderRadius: BorderRadius.circular(16),
              ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent, width: 0),
            borderRadius: BorderRadius.circular(16),
          ),
          hintText: hintText,
          hintStyle: hintStyle ?? TextStyle(color: HexColor('#1F3233').withOpacity(0.7)),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.transparent,
        ),
        style: textStyle ??
            const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
        dropdownColor: fillColor,
      ),
    );
  }
}
