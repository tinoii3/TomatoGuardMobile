import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tomato_guard_mobile/features/cameraPages/analysisActions.dart';
import 'package:tomato_guard_mobile/features/cameraPages/cameraTips.dart';
import 'package:tomato_guard_mobile/features/cameraPages/imagePreview.dart';
import 'package:tomato_guard_mobile/features/cameraPages/uploadPlacholder.dart';
import 'package:tomato_guard_mobile/services/disease_classifier.dart';

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
  final DiseaseClassifier _classifier = DiseaseClassifier();
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _classifier.loadModel();
  }

  @override
  void dispose() {
    _classifier.close();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 100,
        preferredCameraDevice: CameraDevice.rear,
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

  Future<void> _runAnalysis() async {
    if (_selectedImage == null) return;

    setState(() {
      _isAnalyzing = true;
    });

    final result = await _classifier.predict(_selectedImage!);

    setState(() {
      _isAnalyzing = false;
    });

    if (result != null) {
      _showResultDialog(result);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("เกิดข้อผิดพลาดในการวิเคราะห์")),
      );
    }
  }

  void _showResultDialog(Map<String, dynamic> result) {
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
              label,
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
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18, // ผมคงค่า fontSize ตาม logic เดิม
          ),
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
              'ถ่ายรูปหรือเลือกภาพใบมะเขือเทศ',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _selectedImage != null
                  ? ImagePreview(imageFile: _selectedImage!) // ใช้ Widget แยก
                  : UploadPlaceholder(
                      // ใช้ Widget แยก
                      onCameraTap: () => _pickImage(ImageSource.camera),
                      onGalleryTap: () => _pickImage(ImageSource.gallery),
                    ),
            ),

            const SizedBox(height: 20),

            // --- Tips (แสดงเมื่อไม่มีรูป) ---
            if (_selectedImage == null) ...[
              const CameraTips(), // ใช้ Widget แยก
            ],

            // --- Action Buttons (แสดงเมื่อมีรูป) ---
            if (_selectedImage != null) ...[
              const SizedBox(height: 20),
              AnalysisActions(
                // ใช้ Widget แยก
                isAnalyzing: _isAnalyzing,
                onAnalyze: _runAnalysis,
                lastImageSource: _lastImageSource,
                onRetake: () {
                  // เช็คว่ารูปล่าสุดมาจากไหน แล้วเรียกฟังก์ชันเดิม
                  if (_lastImageSource != null) {
                    _pickImage(_lastImageSource!);
                  }
                },
              ),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
