import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tomato_guard_mobile/shared/theme/colors.dart';

class MainCamera extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const MainCamera({super.key, this.onBackPressed});

  @override
  State<MainCamera> createState() => _MainCameraState();
}

class _MainCameraState extends State<MainCamera> {
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
          'สแกนใบมะเขือเทศ',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        titleSpacing: 10,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              'วิเคราะห์โรคด้วย AI',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            const SizedBox(height: 5),
            const Text(
              'ถ่ายรูปหรือเลือกภาพใบมะเขือเทศที่ต้องการตรวจสอบ',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                const Icon(LucideIcons.upload),
                const SizedBox(height: 20),
                const Text(
                  'กรุณาเลือกจากตัวเลือกด้านล่าง',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
