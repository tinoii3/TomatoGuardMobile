import 'package:flutter/material.dart';
import 'package:tomato_guard_mobile/shared/theme/colors.dart';

class ActionButton extends StatelessWidget {
  final IconData? icon;
  final String label;
  final VoidCallback? onTap;
  final bool isOutlined;
  final bool isLoading;

  const ActionButton({
    super.key,
    this.icon,
    required this.label,
    required this.onTap,
    this.isOutlined = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: isOutlined ? null : AppColors.gradientPrimary,
          color: isOutlined ? Colors.transparent : null,
          borderRadius: BorderRadius.circular(12),
          border: isOutlined ? Border.all(color: AppColors.primary) : null,
        ),
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: isOutlined ? AppColors.primary : Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(
                            icon,
                            color: isOutlined
                                ? AppColors.primary
                                : Colors.white,
                          ),
                          const SizedBox(width: 10),
                        ],
                        Text(
                          label,
                          style: TextStyle(
                            color: isOutlined
                                ? AppColors.primary
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
