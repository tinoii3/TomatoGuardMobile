import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class DiseaseClassifier {
  Interpreter? _interpreter;
  List<String>? _labels;

  static const int inputSize = 224;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/models/tomato_disease_model_quant_v3.tflite',
      );
      print('✅ Model loaded successfully');

      final labelData = await rootBundle.loadString('assets/models/labels.txt');
      _labels = labelData
          .split('\n')
          .where((s) => s.trim().isNotEmpty)
          .toList();
      print('✅ Labels loaded: $_labels');

      // --- เพิ่มส่วนนี้เพื่อ Debug ---
      var inputTensor = _interpreter!.getInputTensor(0);
      print(
        "🔍 Model Input Type: ${inputTensor.type}",
      ); // ดูว่าเป็น float32 หรือ uint8
      print("🔍 Model Input Shape: ${inputTensor.shape}");
    } catch (e) {
      print('❌ Failed to load model: $e');
    }
  }

  Future<Map<String, dynamic>?> predict(File imageFile) async {
    if (_interpreter == null || _labels == null) {
      print("❌ Model not loaded");
      return null;
    }

    // 1. อ่านไฟล์
    var imageBytes = await imageFile.readAsBytes();
    var image = img.decodeImage(imageBytes);

    print("📏 Original Size: ${image?.width} x ${image?.height}");
    if (image == null) return null;

    // 2. แก้รูปกลับหัว (สำคัญมาก)
    image = img.bakeOrientation(image);

    // 3. Resize ให้เหมือน OpenCV (ใช้ Linear Interpolation)
    var resizedImage = img.copyResize(
      image,
      width: inputSize,
      height: inputSize,
      interpolation:
          img.Interpolation.average, // เพิ่มตรงนี้เพื่อให้คล้าย cv2.resize
    );

    final directory =
        await getApplicationDocumentsDirectory(); // ต้อง import path_provider
    final debugFile = File('${directory.path}/debug_input.jpg');
    await debugFile.writeAsBytes(img.encodeJpg(resizedImage));
    print("📸 บันทึกรูป Input ของโมเดลไว้ที่: ${debugFile.path}");

    // 4. แปลงข้อมูลลง Buffer (Float32)
    // รูปทรง [1, 224, 224, 3] -> ขนาด array = 1 * 224 * 224 * 3
    var inputBytes = Float32List(1 * inputSize * inputSize * 3);
    int pixelIndex = 0;

    for (var y = 0; y < inputSize; y++) {
      for (var x = 0; x < inputSize; x++) {
        var pixel = resizedImage.getPixel(x, y);

        // Normalize 0.0 - 1.0
        inputBytes[pixelIndex++] = pixel.r / 255.0; // R
        inputBytes[pixelIndex++] = pixel.g / 255.0; // G
        inputBytes[pixelIndex++] = pixel.b / 255.0; // B
      }
    }

    // --- DEBUG: ปริ้นค่า 5 ตัวแรกออกมาดูเทียบกับ Python ---
    print("🔍 Flutter Input (First 5 values): ${inputBytes.sublist(0, 5)}");
    // ---------------------------------------------------

    // 5. เตรียม Tensor
    var inputTensor = inputBytes.reshape([1, inputSize, inputSize, 3]);
    var output = List.filled(
      1 * _labels!.length,
      0.0,
    ).reshape([1, _labels!.length]);

    // 6. Run Model
    try {
      _interpreter!.run(inputTensor, output);
    } catch (e) {
      print("❌ Error running model: $e");
      return null;
    }

    // 7. หาผลลัพธ์
    List<double> result = List<double>.from(output[0]);

    // --- DEBUG: ปริ้นค่า Confidence ทั้งหมดดู ---
    print("🔍 Raw Output: $result");
    // ----------------------------------------

    double maxScore = -1.0;
    int maxIndex = -1;

    for (int i = 0; i < result.length; i++) {
      if (result[i] > maxScore) {
        maxScore = result[i];
        maxIndex = i;
      }
    }

    List<double> gg = List<double>.from(output[0]);

    print("🔍 Raw Confidence Scores:");
    for (int i = 0; i < gg.length; i++) {
      // ปริ้นคะแนนของทุกช่องออกมาดูเลย
      print("  Index $i: ${(gg[i] * 100).toStringAsFixed(2)}%");
    }

    return {
      'label': _labels![maxIndex],
      'confidence': maxScore,
      'index': maxIndex,
    };
  }

  void close() {
    _interpreter?.close();
  }
}
