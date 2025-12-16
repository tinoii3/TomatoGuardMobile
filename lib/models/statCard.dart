import 'package:flutter/material.dart';

class StatCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color themeColor;
  final Color? backgroundColor;
  final bool isOutlined;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.themeColor,
    this.backgroundColor,
    this.isOutlined = false,
  });

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: widget.isOutlined ? Colors.white : widget.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.themeColor.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: widget.isOutlined
            ? [
                BoxShadow(
                  color: widget.themeColor.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.isOutlined
                  ? widget.themeColor.withOpacity(0.1)
                  : Colors.white.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child: Icon(widget.icon, color: widget.themeColor, size: 21),
          ),

          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  widget.value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
