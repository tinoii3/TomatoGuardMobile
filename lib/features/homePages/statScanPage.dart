import 'package:flutter/material.dart';
import 'package:tomato_guard_mobile/models/statCard.dart';
import 'package:tomato_guard_mobile/shared/theme/colors.dart';

class StatScanPage extends StatelessWidget {
  const StatScanPage({super.key});

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
          const SizedBox(height: 10),
          GridView.count(
                      crossAxisCount: 2, // แถวละ 2 กล่อง
                      shrinkWrap: true, // ให้ขยายขนาดเท่าเนื้อหา (เพราะอยู่ใน Column)
                      physics: const NeverScrollableScrollPhysics(), // ปิดการเลื่อนของ Grid (ใช้ Scroll ของหน้าหลักแทน)
                      crossAxisSpacing: 16, // ระยะห่างแนวนอน
                      mainAxisSpacing: 16, // ระยะห่างแนวตั้ง
                      childAspectRatio: 1.5, // สัดส่วน กว้าง:สูง ของกล่อง (ปรับเลขนี้ให้กล่องอ้วน/ผอม)
                      children: [
                        // กล่องที่ 1: สแกนทั้งหมด
                        StatCard(
                          title: "สแกนทั้งหมด",
                          value: "128", // ตัวอย่างข้อมูล
                          icon: Icons.bar_chart_rounded,
                          themeColor: AppColors.primary, // สีเขียวหลัก
                          isOutlined: true, // กล่องนี้พื้นขาว มีขอบ
                        ),
          
                        // กล่องที่ 2: ใบสุขภาพดี
                        StatCard(
                          title: "ใบสุขภาพดี",
                          value: "84",
                          icon: Icons.check_circle_outline_rounded,
                          themeColor: AppColors.success, // สีเขียว Success
                          backgroundColor: AppColors.success.withOpacity(0.1), // พื้นหลังจางๆ
                        ),
          
                        // กล่องที่ 3: พบโรค
                        StatCard(
                          title: "พบโรค",
                          value: "44",
                          icon: Icons.warning_amber_rounded,
                          themeColor: AppColors.warning, // สีส้ม
                          backgroundColor: AppColors.warning.withOpacity(0.1),
                        ),
          
                        // กล่องที่ 4: โรคที่พบบ่อย
                        StatCard(
                          title: "โรคที่พบบ่อย",
                          value: "ราแป้ง", // ตัวอย่างชื่อโรค
                          icon: Icons.eco_outlined, // หรือใช้ icon ใบไม้
                          themeColor: AppColors.destructive, // สีแดง
                          backgroundColor: AppColors.destructive.withOpacity(0.1),
                        ),
                      ],
                    ),
        ],
      ),
    );
  }
}
