import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tomato_guard_mobile/features/homePages/currentScan.dart';
import 'package:tomato_guard_mobile/features/homePages/homePageHeader.dart';
import 'package:tomato_guard_mobile/features/homePages/StatScan.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.95),
        body: SingleChildScrollView(
          child: Column(
            children: [
              HomePageHeader(),
              const SizedBox(height: 150),
              StatScan(),
              const SizedBox(height: 20),
              CurrentScan(),
              const SizedBox(height: 30),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          onTap: (index) {},
          items: [
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.house),
              label: 'หน้าแรก',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.camera),
              label: 'สแกน',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.history),
              label: 'ประวัติ',
            ),
          ],
        ),
      ),
      title: 'My Awesome App',
      debugShowCheckedModeBanner: false,
    );
  }
}
