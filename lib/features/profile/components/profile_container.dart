import 'package:flutter/material.dart';

class ProfileContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsDirectional? margin;
  const ProfileContainer({super.key, required this.child, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 4,
            blurRadius: 6,
            offset: const Offset(4, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}