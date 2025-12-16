import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
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
    } catch (e) {
      print('❌ Failed to load model: $e');
    }
  }

  Future<Map<String, dynamic>?> predict(File imageFile) async {
    if (_interpreter == null || _labels == null) {
      print("❌ Interpreter or labels not loaded");
      return null;
    }

    var imageBytes = await imageFile.readAsBytes();
    var image = img.decodeImage(imageBytes);
    if (image == null) return null;

    var resizedImage = img.copyResize(
      image,
      width: inputSize,
      height: inputSize,
    );

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

    var output = List.filled(
      1 * _labels!.length,
      0.0,
    ).reshape([1, _labels!.length]);

    _interpreter!.run(input, output);

    List<double> result = List<double>.from(output[0]);

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
      'confidence': maxScore,
      'index': maxIndex,
    };
  }

  void close() {
    _interpreter?.close();
  }
}
