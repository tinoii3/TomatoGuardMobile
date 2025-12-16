import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tomato_guard_mobile/shared/theme/colors.dart';
import 'package:tomato_guard_mobile/shared/widget/buttonAction.dart';

class AnalysisActions extends StatelessWidget {
  final bool isAnalyzing;
  final VoidCallback onAnalyze;
  final ImageSource? lastImageSource;
  final VoidCallback onRetake; // สำหรับถ่ายใหม่/เลือกใหม่

  const AnalysisActions({
    super.key,
    required this.isAnalyzing,
    required this.onAnalyze,
    required this.lastImageSource,
    required this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isAnalyzing ? null : onAnalyze,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                shadowColor: AppColors.primary.withOpacity(0.4),
              ),
              child: isAnalyzing
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "เริ่มวิเคราะห์โรค",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          if (lastImageSource == ImageSource.camera)
            SizedBox(
              width: double.infinity,
              child: ActionButton(
                icon: LucideIcons.camera,
                label: "ถ่ายใหม่",
                onTap: onRetake,
                isOutlined: true,
              ),
            )
          else if (lastImageSource == ImageSource.gallery)
            SizedBox(
              width: double.infinity,
              child: ActionButton(
                icon: LucideIcons.image,
                label: "เลือกใหม่",
                onTap: onRetake,
                isOutlined: true,
              ),
            ),
        ],
      ),
    );
  }
}