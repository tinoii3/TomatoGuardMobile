import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tomato_guard_mobile/models/leafRecord.dart';
import 'package:tomato_guard_mobile/services/databaseHelper.dart';
import 'package:tomato_guard_mobile/shared/widget/scanHistoryList.dart';

class CurrentScan extends StatefulWidget {
  final VoidCallback? onSeeAll;
  const CurrentScan({super.key, this.onSeeAll});

  @override
  State<CurrentScan> createState() => _CurrentScanState();
}

class _CurrentScanState extends State<CurrentScan> {
  List<LeafRecord> recentScans = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecentScans();
  }

  // 4. ฟังก์ชันดึงข้อมูลจาก DB
  Future<void> _fetchRecentScans() async {
    final data = await DatabaseHelper.instance.getAllRecords();

    // DB เรา sort DESC (ล่าสุดก่อน) อยู่แล้ว เอามาใช้ได้เลย
    // แต่ถ้าอยากเอาชัวร์ว่าเอามาแค่ 3 ตัวล่าสุดจริงๆ เพื่อความเร็ว ก็ทำได้ (แต่ตอนนี้เอามาหมดแล้วตัดใน View เอา ง่ายกว่า)

    if (mounted) {
      setState(() {
        recentScans = data;
        isLoading = false;
      });
    }
  }

  // ฟังก์ชันเพื่อให้ Parent Widget เรียกใช้ได้ (กรณีสแกนเสร็จแล้วกลับมาหน้าแรก อยากให้รีเฟรช)
  void refreshData() {
    _fetchRecentScans();
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
                "การสแกนล่าสุด",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              if (recentScans.isNotEmpty)
                TextButton(
                  onPressed: widget.onSeeAll,
                  child: const Text(
                    "ดูทั้งหมด",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (recentScans.isEmpty)
            _buildEmptyState()
          else
            ScanHistoryList(
              items: recentScans, // ส่ง List<LeafRecord>
              limit: 3, // จำกัดแค่ 3 รายการล่าสุด
              showDeleteIcon: false, // หน้าแรกไม่ควรมีปุ่มลบ (UX)
              onTap: (index) {
                // TODO: นำทางไปหน้า Detail โดยส่ง recentScans[index] ไป
                print("กดที่รายการ: ${recentScans[index].diseaseName}");
              },
            ),
        ],
      ),
    );
  }

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
}
