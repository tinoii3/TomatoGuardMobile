import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tomato_guard_mobile/features/homePages/currentScan.dart';
import 'package:tomato_guard_mobile/features/homePages/homePageHeader.dart';
import 'package:tomato_guard_mobile/features/homePages/StatScan.dart';
import 'package:tomato_guard_mobile/shared/theme/colors.dart'; // อย่าลืม import ไฟล์สี

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // 1. สร้างตัวแปรเก็บ index หน้าปัจจุบัน
  int _currentIndex = 0;

  // 2. ฟังก์ชันเมื่อกดเปลี่ยนหน้า
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.95),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const HomePageHeader(),
              const SizedBox(height: 150),
              const StatScan(),
              const SizedBox(height: 20),
              const CurrentScan(),
              const SizedBox(height: 30),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          // เพิ่มเงาให้แถบเมนูดูมีมิติขึ้น (Optional)
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,

            items: [
              BottomNavigationBarItem(
                icon: const Icon(LucideIcons.house),
                activeIcon: _buildActiveIcon(LucideIcons.house),
                label: 'หน้าแรก',
              ),
              BottomNavigationBarItem(
                icon: const Icon(LucideIcons.camera),
                activeIcon: _buildActiveIcon(LucideIcons.camera),
                label: 'สแกน',
              ),
              BottomNavigationBarItem(
                icon: const Icon(LucideIcons.history),
                activeIcon: _buildActiveIcon(LucideIcons.history),
                label: 'ประวัติ',
              ),
            ],
          ),
        ),
      ),
      title: 'My Awesome App',
      debugShowCheckedModeBanner: false,
    );
  }

  Widget _buildActiveIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }
}
