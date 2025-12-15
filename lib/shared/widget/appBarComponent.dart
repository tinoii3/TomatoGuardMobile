import 'package:flutter/material.dart';
import 'package:tomato_guard_mobile/shared/theme/colors.dart';

AppBar buildGradientAppBar({
  required String title,
  Widget? leading,
  List<Widget>? actions,
}) {
  return AppBar(
    title: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    centerTitle: false,
    titleSpacing: 10,
    elevation: 0,
    backgroundColor: Colors.transparent,
    leading: leading,
    actions: actions,
    
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: AppColors.gradientPrimary,
      ),
    ),
  );
}