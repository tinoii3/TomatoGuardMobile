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

  Future<void> _fetchRecentScans() async {
    final data = await DatabaseHelper.instance.getAllRecords();

    if (mounted) {
      setState(() {
        recentScans = data;
        isLoading = false;
      });
    }
  }

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
              items: recentScans,
              limit: 3,
              showDeleteIcon: false,
              onTap: (index) {
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
