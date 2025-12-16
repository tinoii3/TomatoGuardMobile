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
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.7,
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
