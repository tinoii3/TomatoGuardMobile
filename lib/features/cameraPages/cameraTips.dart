import 'package:flutter/material.dart';
import 'package:tomato_guard_mobile/shared/theme/colors.dart';

class CameraTips extends StatelessWidget {
  const CameraTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "💡เคล็ดลับการถ่ายรูป",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            _buildTipItem("ถ่ายใบที่แสดงอาการชัดเจน"),
            const SizedBox(height: 6),
            _buildTipItem("ให้แสงสว่างเพียงพอ"),
            const SizedBox(height: 6),
            _buildTipItem("ถ่ายใกล้ๆ ให้เห็นรายละเอียด"),
            const SizedBox(height: 6),
            _buildTipItem("หลีกเลี่ยงแสงสะท้อนหรือเงาบัง"),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8, right: 8, left: 4),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}