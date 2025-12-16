import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ScanHistoryList extends StatelessWidget {
  final List<String> items;
  final int? limit;
  final Function(int index)? onTap;

  final bool showDeleteIcon;
  final Function(int index)? onDelete;

  const ScanHistoryList({
    super.key,
    required this.items,
    this.limit,
    this.onTap,
    this.showDeleteIcon = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final int count = (limit != null && items.length > limit!)
        ? limit!
        : items.length;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: count,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = items[index];

        return GestureDetector(
          onTap: () => onTap?.call(index),
          child: Container(
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "วันนี้, 10:30 น.",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              "ความมั่นใจ: 85%",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (showDeleteIcon)
                  GestureDetector(
                    onTap: () => onDelete?.call(index),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        LucideIcons.trash2,
                        color: Colors.grey[800],
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
