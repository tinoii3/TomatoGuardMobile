import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tomato_guard_mobile/shared/theme/colors.dart';
import 'package:tomato_guard_mobile/shared/widget/buttonAction.dart';

class UploadPlaceholder extends StatelessWidget {
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;

  const UploadPlaceholder({
    super.key,
    required this.onCameraTap,
    required this.onGalleryTap,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        color: AppColors.primary,
        strokeWidth: 1,
        dashPattern: const [8, 4],
        radius: const Radius.circular(24),
      ),
      child: Container(
        width: double.infinity,
        height: 400,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.upload,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'กรุณาเลือกจากตัวเลือกด้านล่าง',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 30),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ActionButton(
                    icon: LucideIcons.camera,
                    label: "ถ่ายรูป",
                    onTap: onCameraTap,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ActionButton(
                    icon: LucideIcons.image,
                    label: "แกลเลอรี่",
                    onTap: onGalleryTap,
                    isOutlined: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}