import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tomato_guard_mobile/shared/theme/colors.dart';

class HomePageHeader extends StatelessWidget {
  final VoidCallback? onScanPressed;
  const HomePageHeader({super.key, this.onScanPressed});

  @override
  Widget build(BuildContext context) {
    // ความสูงเดิม (280) + ส่วนที่ล้นออกมา (130) = 410
    return SizedBox(
      height: 410, 
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter, // เปลี่ยนเป็นยึดด้านบน
        children: [
          // 1. ส่วน Background Gradient (สูง 280 เท่าเดิม)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 280,
            child: Container(
              padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
              decoration: BoxDecoration(
                gradient: AppColors.gradientPrimary.withOpacity(0.9),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          LucideIcons.leaf,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tomato Guard",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "ระบบตรวจโรคใบมะเขือเทศ",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Center(
                    child: Column(
                      children: [
                        Text(
                          "วิเคราะห์โรคพืชด้วย AI",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "ถ่ายรูปใบมะเขือเทศเพื่อตรวจสอบโรค",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 2. ปุ่ม Scan (เปลี่ยนจาก bottom: -130 เป็น bottom: 0 ของกล่องใหญ่)
          Positioned(
            bottom: 0, 
            child: GestureDetector(
              onTap: onScanPressed,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.gradientPrimary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 0,
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.camera, color: Colors.white, size: 55),
                      SizedBox(height: 10),
                      Text(
                        "สแกน",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}