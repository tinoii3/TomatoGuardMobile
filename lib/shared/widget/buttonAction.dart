import 'package:flutter/material.dart';
import 'package:tomato_guard_mobile/shared/theme/colors.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isOutlined;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isOutlined ? Colors.transparent : AppColors.primary,
            borderRadius: BorderRadius.circular(12),
            border: isOutlined ? Border.all(color: AppColors.primary) : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isOutlined ? AppColors.primary : Colors.white),
              const SizedBox(width: 15),
              Text(
                label,
                style: TextStyle(
                  color: isOutlined ? AppColors.primary : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
