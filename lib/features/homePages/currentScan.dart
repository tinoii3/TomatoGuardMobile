import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CurrentScan extends StatefulWidget {
  const CurrentScan({super.key});

  @override
  State<CurrentScan> createState() => _CurrentScanState();
}

class _CurrentScanState extends State<CurrentScan> {
  // สมมติข้อมูล (ลองลบข้อมูลใน [] ให้ว่าง เพื่อเทสหน้า "ยังไม่มีประวัติ")
  final List<String> scanHistory = [
    // "Tomato Leaf 001",
    // "Tomato Leaf 002",
    // "Tomato Leaf 003",
    // "Tomato Leaf 004", // อันนี้จะไม่แสดง เพราะเราจำกัดแค่ 3
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "การสแกนล่าสุด",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10), // เว้นระยะห่างนิดนึง
          // --- ส่วน Logic การแสดงผล ---
          scanHistory.isEmpty
              ? _buildEmptyState() // ถ้าไม่มีข้อมูล เรียก Widget ว่าง
              : _buildHistoryList(), // ถ้ามีข้อมูล เรียก Widget รายการ
        ],
      ),
    );
  }

  // Widget กรณีไม่มีประวัติ
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: const [
          Icon(LucideIcons.leaf, size: 50, color: Colors.grey),
          SizedBox(height: 8),
          Text(
            "ยังไม่มีประวัติการสแกน",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Widget กรณีมีประวัติ (แสดงสูงสุด 3 รายการ)
  Widget _buildHistoryList() {
    // คำนวณจำนวนที่จะแสดง: ถ้ามีน้อยกว่า 3 ก็เอาตามจริง, ถ้ามากกว่า 3 เอาแค่ 3
    final itemCount = scanHistory.length > 3 ? 3 : scanHistory.length;

    return ListView.separated(
      // สำคัญมาก! ถ้าเอา List ไปใส่ใน Column ต้องมี 2 บรรทัดนี้ไม่งั้น Error
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      padding: EdgeInsets.zero,
      itemCount: itemCount,
      separatorBuilder: (context, index) =>
          const SizedBox(height: 10), // ระยะห่างแต่ละแถว
      itemBuilder: (context, index) {
        // ดึงข้อมูลมาแสดง (ในที่นี้ index 0 คือล่าสุด)
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image, color: Colors.green),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scanHistory[index],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    "วันนี้, 10:30 น.",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
