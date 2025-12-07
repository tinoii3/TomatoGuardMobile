import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isOutlined ? Colors.white : backgroundColor,
        borderRadius: BorderRadius.circular(16), // ความโค้งมนตาม Design
        border: Border.all(
          // ถ้าเป็น Outlined ให้มีขอบเข้มหน่อย ถ้าไม่ ให้ขอบจางๆ หรือไม่มี
          color: Colors.black,
          width: 1,
        ),
        boxShadow: isOutlined
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ส่วน Icon และ Title (อาจจะจัด Layout ตามชอบ)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6), // พื้นหลัง Icon จางๆ
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: themeColor, size: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                // เพื่อให้ข้อความยาวๆ ไม่ล้นจอ
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700], // สีเทาเข้ม
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          // ส่วนตัวเลข (Value)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 20, // ตัวเลขใหญ่
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
