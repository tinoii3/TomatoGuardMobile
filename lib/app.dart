import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tomato_guard_mobile/features/cameraPages/mainCamera.dart';
import 'package:tomato_guard_mobile/features/historyPages/mainHistory.dart';
import 'package:tomato_guard_mobile/features/homePages/currentScan.dart';
import 'package:tomato_guard_mobile/features/homePages/homePageHeader.dart';
import 'package:tomato_guard_mobile/features/homePages/statScan.dart';
import 'package:tomato_guard_mobile/shared/theme/colors.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;
  List<Widget> get _pages => [
    SingleChildScrollView(
      child: Column(
        children: [
          HomePageHeader(onScanPressed: () => _onItemTapped(1)),
          SizedBox(height: 20),
          StatScan(),
          SizedBox(height: 20),
          CurrentScan(onSeeAll: () => _onItemTapped(2)),
          SizedBox(height: 30),
        ],
      ),
    ),
    MainCamera(onBackPressed: () => _onItemTapped(0)),
    MainHistory(onBackPressed: () => _onItemTapped(0)),
  ];

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
        body: IndexedStack(index: _currentIndex, children: _pages),

        bottomNavigationBar: Container(
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
      title: 'Tomato Guard',
      debugShowCheckedModeBanner: false,
    );
  }

  Widget _buildActiveIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: AppColors.gradientPrimary,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }
}
