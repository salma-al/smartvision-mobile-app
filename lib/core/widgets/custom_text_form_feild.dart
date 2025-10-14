import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomTextFormField extends StatelessWidget {
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder, enabledBorder;
  final TextStyle? inputTextStyle, hintStyle;
  final bool? isObscureText, readOnly;
  final Widget? prefixIcon, suffixIcon;
  final String hintText;
  final Color? fillColor;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLines;
  final Function()? onTap;

  const CustomTextFormField({
    super.key, 
    this.contentPadding, 
    this.focusedBorder, 
    this.enabledBorder, 
    this.inputTextStyle, 
    this.hintStyle, 
    this.isObscureText, 
    this.suffixIcon, 
    required this.hintText, 
    this.fillColor, 
    this.controller, 
    this.readOnly, 
    this.prefixIcon,
    this.keyboardType,
    this.maxLines,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      controller: controller,
      readOnly: readOnly ?? false,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        isDense: true,
        contentPadding:contentPadding?? const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        focusedBorder:focusedBorder?? OutlineInputBorder(
            borderSide: BorderSide(
              color: HexColor('#FFF8DB').withValues(alpha: 0.2),
              width: 1.3,
            ),
            borderRadius: BorderRadius.circular(16)
        ),
        enabledBorder:enabledBorder?? OutlineInputBorder(
          borderSide: BorderSide(
            color: HexColor('#FFF8DB').withValues(alpha: 0.2),
            width: 1.3,
          ),
            borderRadius: BorderRadius.circular(16)
        ),
        hintText: hintText,
        hintStyle: hintStyle ?? TextStyle(
          fontFamily: 'Colfax',
          color: HexColor('#1F3233')
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: fillColor??HexColor('#FFF8DB').withValues(alpha: 0.2),
      ),
      obscureText:isObscureText?? false,
    );
  }
}
