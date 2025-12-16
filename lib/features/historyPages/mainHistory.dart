import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tomato_guard_mobile/shared/widget/scanHistoryList.dart';

class MainHistory extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const MainHistory({super.key, this.onBackPressed});

  @override
  _MainHistoryState createState() => _MainHistoryState();
}

class _MainHistoryState extends State<MainHistory> {
  List<String> historyItems = [
    "Tomato Leaf 001",
    "Tomato Leaf 002",
    "Tomato Leaf 003",
    "Tomato Leaf 004",
    "Tomato Leaf 005",
    "Tomato Leaf 006",
  ];

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
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
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
                      print("กดดูรายละเอียด: ${historyItems[index]}");
                      // TODO: Navigate to Detail Page
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

  void _deleteItem(int index) {
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
        title: const Text("ยืนยันการลบ"),
        content: const Text("คุณต้องการลบประวัติทั้งหมดใช่หรือไม่?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("ยกเลิก"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                historyItems.clear();
              });
              Navigator.pop(ctx);
            },
            child: const Text("ลบทั้งหมด", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
