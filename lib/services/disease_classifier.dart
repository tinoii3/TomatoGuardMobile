import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class DiseaseClassifier {
  Interpreter? _interpreter;
  List<String>? _labels;

  static const int inputSize = 224; // ตามที่คุณเทรนมา

  Future<void> loadModel() async {
    try {
      // โหลดโมเดล
      _interpreter = await Interpreter.fromAsset(
        'assets/models/tomato_disease_model_quant.tflite',
      );
      print('✅ Model loaded successfully');

      // โหลด Labels
      final labelData = await rootBundle.loadString('assets/models/labels.txt');
      _labels = labelData
          .split('\n')
          .where((s) => s.trim().isNotEmpty)
          .toList();
      print('✅ Labels loaded: $_labels');
    } catch (e) {
      print('❌ Failed to load model: $e');
    }
  }

  Future<Map<String, dynamic>?> predict(File imageFile) async {
    if (_interpreter == null || _labels == null) {
      print("❌ Interpreter or labels not loaded");
      return null;
    }

    // 1. อ่านและแปลงรูปภาพ
    var imageBytes = await imageFile.readAsBytes();
    var image = img.decodeImage(imageBytes);
    if (image == null) return null;

    // 2. Resize ให้เหลือ 224x224
    var resizedImage = img.copyResize(
      image,
      width: inputSize,
      height: inputSize,
    );

    // 3. แปลงเป็น Float32 [1, 224, 224, 3] และ Normalize (0-255 -> 0.0-1.0)
    // สาเหตุ: ใน Python คุณใช้ rescale=1./255
    var input = List.generate(
      1,
      (i) => List.generate(
        inputSize,
        (y) => List.generate(inputSize, (x) {
          var pixel = resizedImage.getPixel(x, y);
          // image package เวอร์ชั่นใหม่ pixel.r, pixel.g, pixel.b คือ int 0-255
          return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
        }),
      ),
    );

    // 4. เตรียม Output
    // Output shape: [1, 6] (1 row, 6 classes)
    var output = List.filled(
      1 * _labels!.length,
      0.0,
    ).reshape([1, _labels!.length]);

    // 5. รันโมเดล
    _interpreter!.run(input, output);

    // 6. อ่านผลลัพธ์
    List<double> result = List<double>.from(output[0]);

    // หาค่าสูงสุด (Argmax)
    double maxScore = -1.0;
    int maxIndex = -1;

    for (int i = 0; i < result.length; i++) {
      if (result[i] > maxScore) {
        maxScore = result[i];
        maxIndex = i;
      }
    }

    return {
      'label': _labels![maxIndex],
      'confidence': maxScore, // ค่าความมั่นใจ (0.0 - 1.0)
      'index': maxIndex,
    };
  }

  void close() {
    _interpreter?.close();
  }
}
