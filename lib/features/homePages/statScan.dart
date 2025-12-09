import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tomato_guard_mobile/models/statCard.dart';
import 'package:tomato_guard_mobile/shared/theme/colors.dart';

class StatScan extends StatelessWidget {
  const StatScan({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "สถิติการสแกน",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          GridView.count(
            crossAxisCount: 2, // แถวละ 2 กล่อง
            shrinkWrap: true, // ให้ขยายขนาดเท่าเนื้อหา (เพราะอยู่ใน Column)
            physics:
                const NeverScrollableScrollPhysics(), // ปิดการเลื่อนของ Grid (ใช้ Scroll ของหน้าหลักแทน)
            crossAxisSpacing: 16, // ระยะห่างแนวนอน
            mainAxisSpacing: 16, // ระยะห่างแนวตั้ง
            childAspectRatio:
                1.7, // สัดส่วน กว้าง:สูง ของกล่อง (ปรับเลขนี้ให้กล่องอ้วน/ผอม)
            children: [
              StatCard(
                title: "สแกนทั้งหมด",
                value: "0",
                icon: LucideIcons.chartColumn,
                themeColor: AppColors.primary,
                isOutlined: true,
              ),
              StatCard(
                title: "ใบสุขภาพดี",
                value: "0",
                icon: LucideIcons.circleCheckBig,
                themeColor: AppColors.success,
                backgroundColor: AppColors.success.withOpacity(0.1),
              ),
              StatCard(
                title: "พบโรค",
                value: "0",
                icon: LucideIcons.triangleAlert,
                themeColor: AppColors.warning,
                backgroundColor: AppColors.warning.withOpacity(0.1),
              ),
              StatCard(
                title: "โรคที่พบบ่อย",
                value: "-",
                icon: LucideIcons.leaf,
                themeColor: AppColors.destructive,
                backgroundColor: AppColors.destructive.withOpacity(0.1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
