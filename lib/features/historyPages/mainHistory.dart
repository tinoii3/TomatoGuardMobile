import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tomato_guard_mobile/models/leafRecord.dart';
import 'package:tomato_guard_mobile/services/databaseHelper.dart';
import 'package:tomato_guard_mobile/shared/theme/colors.dart';
import 'package:tomato_guard_mobile/shared/widget/scanHistoryList.dart';

class MainHistory extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const MainHistory({super.key, this.onBackPressed});

  @override
  _MainHistoryState createState() => _MainHistoryState();
}

class _MainHistoryState extends State<MainHistory> {
  List<LeafRecord> historyItems = [];
  List<LeafRecord> _allRecords = [];

  bool isLoading = true;
  String _selectedFilter = 'All';

  final List<String> _filterOptions = [
    'All',
    'Bacterial Spot',
    'Early Blight',
    'Late Blight',
    'Leaf Mold',
    'Septoria Spot',
    'Healthy',
  ];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => isLoading = true);
    final data = await DatabaseHelper.instance.getAllRecords();
    setState(() {
      _allRecords = data;
      _applyFilter();
      isLoading = false;
    });
  }

  void _applyFilter() {
    if (_selectedFilter == 'All') {
      historyItems = List.from(_allRecords);
    } else {
      String targetDbName = "";
      switch (_selectedFilter) {
        case 'Bacterial Spot':
          targetDbName = 'Tomato_Bacterial_spot';
          break;
        case 'Early Blight':
          targetDbName = 'Tomato_Early_blight';
          break;
        case 'Late Blight':
          targetDbName = 'Tomato_Late_blight';
          break;
        case 'Leaf Mold':
          targetDbName = 'Tomato_Leaf_Mold';
          break;
        case 'Septoria Spot':
          targetDbName = 'Tomato_Septoria_leaf_spot';
          break;
        case 'Healthy':
          targetDbName = 'Tomato_healthy';
          break;
      }

      historyItems = _allRecords.where((record) {
        return record.diseaseName == targetDbName;
      }).toList();
    }
  }

  void _onFilterSelected(String filter) {
    // ถ้าเลือก Filter เดิม ไม่ต้อง Rebuild ให้เปลืองแรง
    if (_selectedFilter == filter) return;

    setState(() {
      _selectedFilter = filter;
      _applyFilter();
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
          if (_allRecords.isNotEmpty)
            IconButton(
              icon: const Icon(LucideIcons.trash2, color: Colors.red),
              onPressed: () => _confirmDeleteAll(),
              tooltip: 'ลบประวัติทั้งหมด',
            ),
          const SizedBox(width: 15),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // --- ส่วน Filter (Header) ---
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: _filterOptions.map((filter) {
                        final isSelected = _selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () => _onFilterSelected(filter),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? AppColors.gradientPrimary
                                    : null,
                                color: isSelected ? null : Colors.grey[100],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.transparent
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Text(
                                filter,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey[700],
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // --- ส่วนรายการ (Body) ---
                Expanded(
                  child: historyItems.isEmpty
                      ? _buildEmptyState()
                      : ScanHistoryList(
                          // เรียกใช้ Widget ที่ปรับจูนแล้วด้านล่าง
                          items: historyItems,
                          // ไม่ต้องส่ง limit ก็ได้ถ้าไม่ได้ใช้
                          showDeleteIcon: true,
                          onDelete: (index) => _deleteItem(index),
                          onTap: (index) {
                            // Handle tap
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.history, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            _selectedFilter == 'All'
                ? "ไม่มีประวัติ"
                : "ไม่พบข้อมูล $_selectedFilter",
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
      _allRecords.removeWhere((r) => r.recordId == recordToDelete.recordId);
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
                      _allRecords.clear();
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
