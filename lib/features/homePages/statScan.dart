import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tomato_guard_mobile/models/statCard.dart';
import 'package:tomato_guard_mobile/shared/theme/colors.dart';
import 'package:tomato_guard_mobile/services/databaseHelper.dart'; // อย่าลืม import

class StatScan extends StatefulWidget {
  const StatScan({super.key});

  @override
  State<StatScan> createState() => _StatScanState();
}

class _StatScanState extends State<StatScan> {
  int total = 0;
  int healthy = 0;
  int diseased = 0;
  String mostCommon = "-";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await DatabaseHelper.instance.getStats();

    if (mounted) {
      setState(() {
        total = stats['total'];
        healthy = stats['healthy'];
        diseased = stats['diseased'];
        mostCommon = stats['mostCommon'];
        isLoading = false;
      });
    }
  }

  void refresh() {
    _loadStats();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "สถิติการสแกน",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              // IconButton(
              //   icon: const Icon(
              //     LucideIcons.refreshCw,
              //     size: 16,
              //     color: Colors.grey,
              //   ),
              //   onPressed: _loadStats,
              // ),
            ],
          ),
          const SizedBox(height: 16),

          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            GridView.count(
              crossAxisCount: 1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 4.8,
              children: [
                StatCard(
                  title: "สแกนทั้งหมด",
                  value: "$total",
                  icon: LucideIcons.chartColumn,
                  themeColor: AppColors.primary,
                  isOutlined: true,
                ),
                StatCard(
                  title: "ใบสุขภาพดี",
                  value: "$healthy",
                  icon: LucideIcons.circleCheckBig,
                  themeColor: AppColors.success,
                  backgroundColor: AppColors.success.withOpacity(0.1),
                ),
                StatCard(
                  title: "พบโรค",
                  value: "$diseased",
                  icon: LucideIcons.triangleAlert,
                  themeColor: AppColors.warning,
                  backgroundColor: AppColors.warning.withOpacity(0.1),
                ),
                StatCard(
                  title: "โรคที่พบบ่อย",
                  value: mostCommon,
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
