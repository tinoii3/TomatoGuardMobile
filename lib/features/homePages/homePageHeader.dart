import 'package:flutter/material.dart';
import 'package:tomato_guard_mobile/shared/theme/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePageHeader extends StatelessWidget {
  const HomePageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: 280,
          padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
          decoration: BoxDecoration(
            gradient: AppColors.gradientPrimary.withOpacity(0.9),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  FaIcon(FontAwesomeIcons.leaf, color: Colors.white, size: 35),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tomato Guard",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        "ระบบตรวจโรคใบมะเขือเทศ",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Center(
                child: Column(
                  children: [
                    Text(
                      "วิเคราะห์โรคพืชด้วย AI",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "ถ่ายรูปใบมะเขือเทศเพื่อตรวจสอบโรค",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -130,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.gradientPrimary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),

            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 0,
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.camera,
                    color: Colors.white,
                    size: 55,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "สแกน",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
