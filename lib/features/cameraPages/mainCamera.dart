import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tomato_guard_mobile/services/disease_classifier.dart';
import 'package:tomato_guard_mobile/shared/theme/colors.dart';
import 'package:tomato_guard_mobile/shared/widget/buttonAction.dart';

class MainCamera extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const MainCamera({super.key, this.onBackPressed});

  @override
  State<MainCamera> createState() => _MainCameraState();
}

class _MainCameraState extends State<MainCamera> {
  File? _selectedImage;

  ImageSource? _lastImageSource;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 100,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _lastImageSource = source;
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  void _clearImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  // เพิ่มตัวแปร Classifier
  final DiseaseClassifier _classifier = DiseaseClassifier();
  bool _isAnalyzing = false; // เอาไว้หมุนติ้วๆ ตอนโหลด

  @override
  void initState() {
    super.initState();
    _classifier.loadModel(); // โหลดโมเดลตอนเปิดหน้า
  }

  @override
  void dispose() {
    _classifier.close(); // ปิดคืนเมมโมรี่
    super.dispose();
  }

  Future<void> _runAnalysis() async {
    if (_selectedImage == null) return;

    setState(() {
      _isAnalyzing = true;
    });

    // ส่งรูปไปให้ Class ที่เราเขียนไว้
    final result = await _classifier.predict(_selectedImage!);

    setState(() {
      _isAnalyzing = false;
    });

    if (result != null) {
      // แสดงผลลัพธ์ (เบื้องต้นใช้ Dialog ง่ายๆ ก่อน)
      _showResultDialog(result);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("เกิดข้อผิดพลาดในการวิเคราะห์")),
      );
    }
  }

  void _showResultDialog(Map<String, dynamic> result) {
    // แปลงชื่อโรคเป็นภาษาไทย (ตัวอย่าง)
    String label = result['label'];
    double confidence = result['confidence'] * 100;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(LucideIcons.scanLine, color: Colors.blue),
            SizedBox(width: 8),
            Text("ผลการวิเคราะห์"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("โรคที่ตรวจพบ:", style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 4),
            Text(
              label, // หรือจะ Map ชื่อไทยตรงนี้ก็ได้
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Text("ความมั่นใจ:", style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 4),
            Text(
              "${confidence.toStringAsFixed(2)}%",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: confidence > 80 ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ตกลง", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

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
        actions: [
          if (_selectedImage != null)
            IconButton(
              icon: const Icon(LucideIcons.trash2, color: Colors.red),
              onPressed: _clearImage,
              tooltip: 'ลบรูปภาพ',
            ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 35),
            const Text(
              'วิเคราะห์โรคด้วย AI',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'ถ่ายรูปหรือเลือกภาพใบมะเขือเทศที่ต้องการตรวจสอบ',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(height: 20),

            // --- ส่วนที่ 1: แสดงรูปภาพ หรือ กล่องอัปโหลด ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _selectedImage != null
                  ? _buildImagePreview()
                  : _buildUploadPlaceholder(),
            ),

            const SizedBox(height: 20),

            // --- ส่วนที่ 2: Tips (แสดงตลอด) ---
            if (_selectedImage == null) ...[
              Padding(
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
              ),
            ],

            // --- ส่วนที่ 3: ปุ่ม Action (แสดงเฉพาะตอนมีรูป และอยู่ใต้ Tips) ---
            if (_selectedImage != null) ...[
              const SizedBox(height: 20),
              _buildAnalysisActions(),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Widget 1: แสดงรูปภาพเต็มกรอบ (ไม่มีปุ่มข้างในแล้ว)
  Widget _buildImagePreview() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      // ClipRRect ตัดขอบรูปให้มนทั้ง 4 ด้าน
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.file(
          _selectedImage!,
          width: double.infinity,
          height: 270,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Widget 2: กล่องอัปโหลด (เส้นประ)
  Widget _buildUploadPlaceholder() {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        color: AppColors.primary,
        strokeWidth: 1,
        dashPattern: const [8, 4],
        radius: const Radius.circular(24),
      ),
      child: Container(
        width: double.infinity,
        height: 270,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.upload,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'กรุณาเลือกจากตัวเลือกด้านล่าง',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ActionButton(
                    icon: LucideIcons.camera,
                    label: "ถ่ายรูป",
                    onTap: () => _pickImage(ImageSource.camera),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ActionButton(
                    icon: LucideIcons.image,
                    label: "แกลเลอรี่",
                    onTap: () => _pickImage(ImageSource.gallery),
                    isOutlined: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget 3: ปุ่ม Action ต่างๆ (แยกออกมาแสดงด้านล่างสุด)
  Widget _buildAnalysisActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              // 5. เชื่อมปุ่มกับฟังก์ชัน _runAnalysis
              onPressed: _isAnalyzing ? null : _runAnalysis,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                shadowColor: AppColors.primary.withOpacity(0.4),
              ),
              child: _isAnalyzing
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "เริ่มวิเคราะห์โรค",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          if (_lastImageSource == ImageSource.camera)
            SizedBox(
              width: double.infinity,
              child: ActionButton(
                icon: LucideIcons.camera,
                label: "ถ่ายใหม่",
                onTap: () => _pickImage(ImageSource.camera),
                isOutlined: true,
              ),
            )
          else if (_lastImageSource == ImageSource.gallery)
            SizedBox(
              width: double.infinity,
              child: ActionButton(
                icon: LucideIcons.image,
                label: "เลือกใหม่",
                onTap: () => _pickImage(ImageSource.gallery),
                isOutlined: true,
              ),
            ),
        ],
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
