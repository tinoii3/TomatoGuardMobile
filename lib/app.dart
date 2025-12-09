import 'package:flutter/material.dart';
import 'package:tomato_guard_mobile/features/homePages/homePageHeader.dart';
import 'package:tomato_guard_mobile/features/homePages/StatScan.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.95),
        body: Column(
          children: [
            HomePageHeader(),
            const SizedBox(height: 150),
            StatScan(),
          ],
        ),
      ),
      title: 'My Awesome App',
      debugShowCheckedModeBanner: false,
    );
  }
}
