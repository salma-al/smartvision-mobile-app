import 'package:flutter/material.dart';

import '../../../core/widgets/custom_text_form_feild.dart';

class LeaveDateComponent extends StatelessWidget {
  final String title, hintTitle;
  final TextEditingController controller;
  final VoidCallback onTap;
  const LeaveDateComponent({super.key, required this.title, required this.hintTitle, required this.controller, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: controller,
            hintText: hintTitle,
            readOnly: true,
            onTap: onTap,
            fillColor: Colors.grey.withOpacity(0.2),
          ),
        ],
      ),
    );
  }
}