import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';

class TFLiteService {
  Interpreter? _interpreter;
  List<String> _labels = [];

  Future<void> loadModel() async {
    try {
      // Load the TFLite model
      _interpreter = await Interpreter.fromAsset('assets/first_model.tflite');

      // Load Labels
      final labelData = await rootBundle.loadString('assets/labels.txt');
      _labels = labelData.split('\n').map((e) => e.trim()).toList();

      print(" Model & Labels Loaded Successfully!");
    } catch (e) {
      print(" Error Loading Model: $e");
    }
  }

  /// Run inference on input image data
  String runModel(Uint8List inputImage) {
    if (_interpreter == null) {
      print("⚠️ Model not loaded");
      return "Model not loaded";
    }

    // Process input & Run inference
    var output = List.filled(1, 0).reshape([1, 1]);
    _interpreter!.run(inputImage, output);

    // Get predicted label
    int labelIndex = output[0][0];
    return _labels[labelIndex]; // Convert output to label
  }

  void close() {
    _interpreter?.close();
  }
}
