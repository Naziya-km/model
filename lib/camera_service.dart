import 'package:camera/camera.dart';

class CameraService {
  CameraController? _controller;

  Future<CameraController> initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    await _controller?.initialize();
    return _controller!;
  }

  Future<void> disposeCamera() async {
    await _controller?.dispose();
  }
}
