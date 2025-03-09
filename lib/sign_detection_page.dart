import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'tflite_service.dart';
import 'subtitle_service.dart';
import 'camera_service.dart';
import 'dart:typed_data';

class SignDetectionPage extends StatefulWidget {
  const SignDetectionPage({super.key});

  @override
  _SignDetectionPageState createState() => _SignDetectionPageState();
}

class _SignDetectionPageState extends State<SignDetectionPage> {
  final TFLiteService _tfliteService = TFLiteService();
  final SubtitleService _subtitleService = SubtitleService();
  final CameraService _cameraService = CameraService();

  CameraController? _cameraController;
  String detectedSign = "Waiting for input...";

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await _tfliteService.loadModel();
    _cameraController = await _cameraService.initializeCamera();

    _cameraController!.startImageStream((CameraImage image) {
      processFrame(image);
    });

    setState(() {});
  }

  void processFrame(CameraImage image) async {
    Uint8List imageData = convertCameraImage(image);
    String result = _tfliteService.runModel(imageData);

    setState(() {
      detectedSign = result;
    });

    _subtitleService.speak(detectedSign);
  }

  Uint8List convertCameraImage(CameraImage image) {
    List<int> bytes = [];
    for (var plane in image.planes) {
      bytes.addAll(plane.bytes);
    }
    return Uint8List.fromList(bytes);
  }

  @override
  void dispose() {
    _cameraService.disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Detection")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _cameraController == null || !_cameraController!.value.isInitialized
              ? Center(child: CircularProgressIndicator())
              : SizedBox(height: 300, child: CameraPreview(_cameraController!)),
          SizedBox(height: 20),
          Text(detectedSign, style: TextStyle(fontSize: 24)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              processFrame(_cameraController!.value.previewSize as CameraImage);
            },
            child: Text("Detect Sign"),
          ),
        ],
      ),
    );
  }
}
