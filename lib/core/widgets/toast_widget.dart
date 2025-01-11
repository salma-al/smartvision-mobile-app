import 'package:flutter/material.dart';

class ToastWidget {
  showToast(String message, context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}