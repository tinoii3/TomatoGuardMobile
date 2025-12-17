import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tomato_guard_mobile/models/leafRecord.dart';
import 'package:tomato_guard_mobile/services/databaseHelper.dart';
import 'package:tomato_guard_mobile/shared/widget/scanHistoryList.dart';

class MainHistory extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const MainHistory({super.key, this.onBackPressed});

  @override
  _MainHistoryState createState() => _MainHistoryState();
}

class _MainHistoryState extends State<MainHistory> {
  List<LeafRecord> historyItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => isLoading = true);
    final data = await DatabaseHelper.instance.getAllRecords();
    setState(() {
      historyItems = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.black),
          onPressed: () {
            if (widget.onBackPressed != null) {
              widget.onBackPressed!();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: const Text(
          'ประวัติการสแกน',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        titleSpacing: 10,
        elevation: 0,
        actions: [
          if (historyItems.isNotEmpty)
            IconButton(
              icon: const Icon(LucideIcons.trash2, color: Colors.red),
              onPressed: () => _confirmDeleteAll(),
              tooltip: 'ลบประวัติทั้งหมด',
            ),
          SizedBox(width: 15),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  historyItems.isEmpty
                      ? _buildEmptyState()
                      : ScanHistoryList(
                          items: historyItems,
                          limit: null,
                          showDeleteIcon: true,
                          onDelete: (index) => _deleteItem(index),
                          onTap: (index) {
                            // การส่งค่าไปหน้า Detail สามารถส่ง record object ไปได้เลย
                            // เช่น Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(record: historyItems[index])));
                          },
                        ),
                  const SizedBox(height: 35),
                ],
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          Icon(LucideIcons.history, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "ไม่มีประวัติ",
            style: TextStyle(fontSize: 18, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteItem(int index) async {
    final recordToDelete = historyItems[index];

    if (recordToDelete.recordId != null) {
      await DatabaseHelper.instance.deleteRecord(recordToDelete.recordId!);
    }

    setState(() {
      historyItems.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("ลบรายการเรียบร้อย"),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _confirmDeleteAll() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "ลบประวัติทั้งหมด",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text("คุณต้องการลบประวัติทั้งหมดใช่หรือไม่?"),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),

        actions: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("ยกเลิก"),
                ),
              ),

              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await DatabaseHelper.instance.deleteAllRecords();
                    setState(() {
                      historyItems.clear();
                    });
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("ลบทั้งหมด"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
