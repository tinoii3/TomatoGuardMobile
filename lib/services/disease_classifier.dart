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
        'assets/models/tomato_disease_model_quant.tflite',
      );
      print('✅ Model loaded successfully');

      final labelData = await rootBundle.loadString('assets/models/labels.txt');
      _labels = labelData
          .split('\n')
          .where((s) => s.trim().isNotEmpty)
          .toList();
      print('✅ Labels loaded: $_labels');

      var inputTensor = _interpreter!.getInputTensor(0);
      print("🔍 Model Input Type: ${inputTensor.type}");
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

    var imageBytes = await imageFile.readAsBytes();
    var image = img.decodeImage(imageBytes);

    print("📏 Original Size: ${image?.width} x ${image?.height}");
    if (image == null) return null;

    image = img.bakeOrientation(image);

    var resizedImage = img.copyResize(
      image,
      width: inputSize,
      height: inputSize,
      interpolation: img.Interpolation.average,
    );

    final directory = await getApplicationDocumentsDirectory();
    final debugFile = File('${directory.path}/debug_input.jpg');
    await debugFile.writeAsBytes(img.encodeJpg(resizedImage));
    print("📸 บันทึกรูป Input ของโมเดลไว้ที่: ${debugFile.path}");

    var inputBytes = Float32List(1 * inputSize * inputSize * 3);
    int pixelIndex = 0;

    for (var y = 0; y < inputSize; y++) {
      for (var x = 0; x < inputSize; x++) {
        var pixel = resizedImage.getPixel(x, y);

        inputBytes[pixelIndex++] = (pixel.r - 127.5) / 127.5;
        inputBytes[pixelIndex++] = (pixel.g - 127.5) / 127.5;
        inputBytes[pixelIndex++] = (pixel.b - 127.5) / 127.5;
      }
    }

    print("🔍 Flutter Input (First 5 values): ${inputBytes.sublist(0, 5)}");

    var inputTensor = inputBytes.reshape([1, inputSize, inputSize, 3]);
    var output = List.filled(
      1 * _labels!.length,
      0.0,
    ).reshape([1, _labels!.length]);

    try {
      _interpreter!.run(inputTensor, output);
    } catch (e) {
      print("❌ Error running model: $e");
      return null;
    }

    List<double> result = List<double>.from(output[0]);

    print("🔍 Raw Output: $result");

    double maxScore = -1.0;
    int maxIndex = -1;

    for (int i = 0; i < result.length; i++) {
      if (result[i] > maxScore) {
        maxScore = result[i];
        maxIndex = i;
      }
    }

    print("🔍 Raw Confidence Scores:");
    for (int i = 0; i < result.length; i++) {
      String label = (i < _labels!.length) ? _labels![i] : "Index $i";
      print("  👉 $label: ${(result[i] * 100).toStringAsFixed(2)}%");
    }

    String predictedLabel = _labels![maxIndex];
    if (predictedLabel == 'Unknown' || maxScore < 0.70) {
      print("⚠️ ตรวจพบ Unknown หรือ ความมั่นใจต่ำ ($maxScore)");
      return {
        'label': 'Unknown',
        'confidence': maxScore,
        'index': -1,
        'debugImagePath': debugFile.path,
      };
    }

    return {
      'label': _labels![maxIndex],
      'confidence': maxScore,
      'index': maxIndex,
      'debugImagePath': debugFile.path,
    };
  }

  void close() {
    _interpreter?.close();
  }
}
