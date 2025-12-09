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
          // เปลี่ยนสีขอบเป็นสี themeColor แบบจางลง (0.3 - 0.5 กำลังดีครับ)
          color: widget.themeColor.withOpacity(0.3),
          width: 1.5, // เพิ่มความหนานิดนึงเพื่อให้เห็นสีชัดขึ้น
        ),
        boxShadow: widget.isOutlined
            ? [
                BoxShadow(
                  color: widget.themeColor.withOpacity(
                    0.1,
                  ), // เงาก็ใช้สี Theme อ่อนๆ ได้นะครับ
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center, // จัดให้อยู่กึ่งกลางแนวตั้ง
        children: [
          // --- ส่วน Icon ด้านซ้าย ---
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: widget.isOutlined
                  ? widget.themeColor.withOpacity(0.1)
                  : Colors.white.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child: Icon(widget.icon, color: widget.themeColor, size: 24),
          ),

          const SizedBox(width: 16), // ระยะห่างระหว่าง Icon กับ Text (ตามที่ขอ)
          // --- ส่วน Text และ Value ด้านขวา ---
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // จัดกลางแนวตั้ง
              crossAxisAlignment: CrossAxisAlignment.start, // จัดชิดซ้าย
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 14, // ปรับขนาด Text หัวข้อ
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2), // ระยะห่างระหว่างหัวข้อกับตัวเลข
                Text(
                  widget.value,
                  style: TextStyle(
                    fontSize: 20, // ปรับขนาด Value
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
