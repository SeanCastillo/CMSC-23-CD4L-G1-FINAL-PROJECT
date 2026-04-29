import 'package:camera/camera.dart';

class CameraService {
  static late List<CameraDescription> cameras;

  static Future<void> init() async {
    cameras = await availableCameras();
  }

  static CameraDescription get frontCamera =>
      cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
      );
}