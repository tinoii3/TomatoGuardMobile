import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tomato_guard_mobile/features/cameraPages/analysisActions.dart';
import 'package:tomato_guard_mobile/features/cameraPages/cameraTips.dart';
import 'package:tomato_guard_mobile/features/cameraPages/imagePreview.dart';
import 'package:tomato_guard_mobile/features/cameraPages/uploadPlacholder.dart';
import 'package:tomato_guard_mobile/models/leafRecord.dart';
import 'package:tomato_guard_mobile/services/databaseHelper.dart';
import 'package:tomato_guard_mobile/services/disease_classifier.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

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
    DatabaseHelper.instance.debugCheckDiseases();
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

  // ฟังก์ชันช่วย Save รูปจาก Cache ไปยัง App Doc Dir
  Future<String> _saveImagePermanently(File sourceFile) async {
    final directory = await getApplicationDocumentsDirectory();

    final fileName =
        'tomato_img_${DateTime.now().millisecondsSinceEpoch}${path.extension(sourceFile.path)}';
    final newPath = path.join(directory.path, fileName);
    final savedImage = await sourceFile.copy(newPath);

    return savedImage.path;
  }

  // ฟังก์ชันสำหรับบันทึกข้อมูลลง SQLite
  Future<void> _saveResultToDB(String label, double confidenceScore) async {
    try {
      if (_selectedImage == null) return;

      String cleanLabel = label.trim();

      print("Raw Label: '$label'");
      print("Clean Label: '$cleanLabel'");

      int? diseaseId = await DatabaseHelper.instance.getDiseaseIdByName(
        cleanLabel,
      );

      print("diseaseId: $diseaseId");

      if (diseaseId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("ไม่พบข้อมูลโรค: $label ในฐานข้อมูล")),
        );
        return;
      }

      String permanentPath = await _saveImagePermanently(_selectedImage!);
      bool isHealthy = label.toLowerCase().contains('healthy');

      final newRecord = LeafRecord(
        diseaseId: diseaseId,
        imagePath: permanentPath,
        isHealthy: isHealthy,
        confidence: confidenceScore,
        createdAt: DateTime.now(),
      );

      await DatabaseHelper.instance.insertRecord(newRecord);

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("บันทึกข้อมูลเรียบร้อยแล้ว"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print("Save Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("เกิดข้อผิดพลาด: $e")));
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
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ยกเลิก", style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () async {
              await _saveResultToDB(label, confidence);
            },
            child: const Text("บันทึก", style: TextStyle(color: Colors.blue)),
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
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        titleSpacing: 10,
        elevation: 0,
        actions: [
          if (_selectedImage != null)
            IconButton(
              icon: const Icon(LucideIcons.refreshCcw, color: Colors.black),
              onPressed: _clearImage,
              tooltip: 'ลบรูปภาพ',
            ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
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
                  ? ImagePreview(imageFile: _selectedImage!)
                  : UploadPlaceholder(
                      onCameraTap: () => _pickImage(ImageSource.camera),
                      onGalleryTap: () => _pickImage(ImageSource.gallery),
                    ),
            ),

            const SizedBox(height: 20),

            if (_selectedImage == null) ...[const CameraTips()],

            if (_selectedImage != null) ...[
              const SizedBox(height: 20),
              AnalysisActions(
                isAnalyzing: _isAnalyzing,
                onAnalyze: _runAnalysis,
                lastImageSource: _lastImageSource,
                onRetake: () {
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
