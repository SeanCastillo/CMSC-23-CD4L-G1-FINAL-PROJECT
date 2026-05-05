import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// =====================================================
// CAMERA CAPTURE PAGE (FACE VERIFICATION)
// =====================================================
class CameraCapturePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraCapturePage({super.key, required this.cameras});

  @override
  State<CameraCapturePage> createState() => _CameraCapturePageState();
}

class _CameraCapturePageState extends State<CameraCapturePage> {
  // =====================================================
  // CAMERA + FACE DETECTOR
  // =====================================================
  CameraController? _controller;

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      performanceMode: FaceDetectorMode.fast,
      enableTracking: true,
      enableClassification: true,
    ),
  );

  // --- STATE FLAGS ---
  bool _isProcessing = false;
  bool _isCaptured = false;
  bool _isLoading = false;

  // --- UI STATE ---
  String _hint = "Align your face inside the guide";
  bool _isFaceValidUI = false;

  // --- HOLD TIMER (FACE STILLNESS) ---
  DateTime? _holdStart;
  double _progress = 0.0;
  final int _requiredHoldMs = 3000;

  // --- BLINK DETECTION ---
  DateTime? _eyesClosedStart;
  bool _bothClosedFrame = false;
  bool _blinkDetected = false;

  final int _maxClosedMs = 500;

  // =====================================================
  // FACE ORIENTATION CHECK
  // =====================================================
  bool _isFacingFront(Face face) {
    final yaw = face.headEulerAngleY ?? 0;
    final pitch = face.headEulerAngleX ?? 0;
    final roll = face.headEulerAngleZ ?? 0;

    return yaw.abs() < 8 && pitch.abs() < 10 && roll.abs() < 8;
  }

  bool _eyesSymmetric(Face face) {
    final l = face.leftEyeOpenProbability;
    final r = face.rightEyeOpenProbability;

    if (l == null || r == null) return true;

    return (l - r).abs() < 0.25;
  }

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  // =====================================================
  // INITIALIZE CAMERA
  // =====================================================
  Future<void> _initCamera() async {
    try {
      final cam = widget.cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
      );

      _controller = CameraController(
        cam,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.nv21,
      );

      await _controller!.initialize();

      if (!mounted) return;

      setState(() {});
      await Future.delayed(const Duration(milliseconds: 300));
      _startDetection();
    } catch (_) {
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  // =====================================================
  // START FACE DETECTION STREAM
  // =====================================================
  void _startDetection() {
    _controller!.startImageStream((image) async {
      if (_isProcessing || _isCaptured || _isLoading) return;

      _isProcessing = true;

      try {
        final input = _convert(image);
        final faces = await _faceDetector.processImage(input);

        // --- NO FACE ---
        if (faces.isEmpty) {
          _isFaceValidUI = false;
          _resetAll();
          _updateHint("No face detected");
        } else {
          final face = faces.first;

          final eyesValid = _handleEyes(face);
          final faceValid = _isFaceInsideOval(face);
          final frontValid = _isFacingFront(face);
          final symmetryValid = _eyesSymmetric(face);

          _isFaceValidUI =
              eyesValid && faceValid && frontValid && symmetryValid;

          // --- VALIDATION FLOW ---
          if (!eyesValid) {
            _resetHold();
            _updateHint("Keep both eyes open");
          } else if (!frontValid) {
            _resetHold();
            _updateHint("Face the camera directly");
          } else if (!symmetryValid) {
            _resetHold();
            _updateHint("Face the camera directly");
          } else if (!faceValid) {
            _resetHold();
            _updateHint("Align your face inside the oval");
          } else {
            if (!_blinkDetected) {
              _updateHint("Blink both eyes");
              _resetHold();
            } else {
              _updateHint("Hold still...");
              _handleHold();
            }
          }

          setState(() {});
        }
      } catch (_) {}

      _isProcessing = false;
    });
  }

  // =====================================================
  // BLINK DETECTION LOGIC
  // =====================================================
  bool _handleEyes(Face face) {
    final l = face.leftEyeOpenProbability;
    final r = face.rightEyeOpenProbability;

    if (l == null || r == null) return true;

    final bothClosed = l < 0.3 && r < 0.3;
    final oneClosed = (l < 0.3 && r > 0.6) || (r < 0.3 && l > 0.6);

    if (oneClosed) {
      _blinkDetected = false;
      _bothClosedFrame = false;
      _eyesClosedStart = null;
      return false;
    }

    if (bothClosed) {
      _eyesClosedStart ??= DateTime.now();

      final elapsed = DateTime.now()
          .difference(_eyesClosedStart!)
          .inMilliseconds;

      if (elapsed > _maxClosedMs) return false;

      _bothClosedFrame = true;
    } else {
      if (_bothClosedFrame) {
        _blinkDetected = true;
      }

      _bothClosedFrame = false;
      _eyesClosedStart = null;
    }

    return true;
  }

  // =====================================================
  // HOLD FACE STILL LOGIC
  // =====================================================
  void _handleHold() {
    _holdStart ??= DateTime.now();

    final elapsed = DateTime.now().difference(_holdStart!).inMilliseconds;

    _progress = (elapsed / _requiredHoldMs).clamp(0.0, 1.0);

    setState(() {});

    if (_progress >= 1.0) {
      _isCaptured = true;
      _isLoading = true;
      setState(() {});
      Future.delayed(const Duration(milliseconds: 300), _capture);
    }
  }

  void _resetHold() {
    _holdStart = null;
    _progress = 0;
  }

  void _resetAll() {
    _resetHold();
    _eyesClosedStart = null;
    _bothClosedFrame = false;
    _blinkDetected = false;
    setState(() {});
  }

  // =====================================================
  // FACE POSITION VALIDATION (OVAL GUIDE)
  // =====================================================
  bool _isFaceInsideOval(Face face) {
    final box = face.boundingBox;
    final preview = _controller!.value.previewSize!;

    final cx = box.center.dx / preview.width;
    final cy = box.center.dy / preview.height;

    final dx = (cx - 0.5) / (0.65 / 2);
    final dy = (cy - 0.4) / ((0.65 * 1.2) / 2);

    final inside = (dx * dx + dy * dy) <= 1.15;

    final ratio = (box.width * box.height) / (preview.width * preview.height);

    return inside && ratio > 0.07 && ratio < 0.55;
  }

  // =====================================================
  // CAPTURE IMAGE
  // =====================================================
  Future<void> _capture() async {
    try {
      await _controller!.stopImageStream();

      final file = await _controller!.takePicture();
      final isValid = await _validate(File(file.path));

      if (!mounted) return;

      if (isValid) {
        Navigator.pop(context, File(file.path));
      } else {
        _isCaptured = false;
        _isLoading = false;

        _resetAll();
        _updateHint("Try again");

        setState(() {});
        _startDetection();
      }
    } catch (_) {}
  }

  // =====================================================
  // FINAL VALIDATION (image captured is checked)
  // =====================================================
  Future<bool> _validate(File file) async {
    final input = InputImage.fromFile(file);
    final faces = await _faceDetector.processImage(input);

    if (faces.isEmpty) return false;

    final face = faces.first;

    final l = face.leftEyeOpenProbability;
    final r = face.rightEyeOpenProbability;

    if (l != null && r != null) {
      if (l < 0.2 && r < 0.2) return false;
    }

    final frontValid = _isFacingFront(face);
    final symmetryValid = _eyesSymmetric(face);

    if (!frontValid || !symmetryValid) return false;

    return _blinkDetected;
  }

  // =====================================================
  // CAMERA IMAGE TO MLKIT INPUT CONVERSION (KYSSS!!!!!!!!!!!!)
  // =====================================================
  InputImage _convert(CameraImage image) {
    final rotation =
        InputImageRotationValue.fromRawValue(
          _controller!.description.sensorOrientation,
        ) ??
        InputImageRotation.rotation0deg;

    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: InputImageFormat.nv21,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  // =====================================================
  // UPDATE UI HINT
  // =====================================================
  void _updateHint(String text) {
    if (_hint != text && mounted) {
      setState(() => _hint = text);
    }
  }

  // =====================================================
  // CLEANUP
  // =====================================================
  @override
  void dispose() {
    _controller?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  // =====================================================
  // UI
  // =====================================================
  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final size = MediaQuery.of(context).size;
    final w = size.width * 0.65;
    final h = w * 1.2;

    final ringColor = _isFaceValidUI ? Colors.green : Colors.red;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller!.value.previewSize!.height,
                height: _controller!.value.previewSize!.width,
                child: CameraPreview(_controller!),
              ),
            ),
          ),
          Positioned.fill(child: CustomPaint(painter: _OverlayPainter(w, h))),
          Center(
            child: SizedBox(
              width: w,
              height: h,
              child: CustomPaint(
                painter: _OvalPainter(progress: _progress, color: ringColor),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.75),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                _hint,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// =====================================================
// UI
// =====================================================

class _OverlayPainter extends CustomPainter {
  final double w;
  final double h;

  _OverlayPainter(this.w, this.h);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.6);

    final full = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final hole = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: w,
            height: h,
          ),
          Radius.circular(h),
        ),
      );

    final path = Path.combine(PathOperation.difference, full, hole);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _OvalPainter extends CustomPainter {
  final double progress;
  final Color color;

  _OvalPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final base = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final prog = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(size.height)));

    canvas.drawPath(path, base);

    final metric = path.computeMetrics().first;
    final extract = metric.extractPath(0, metric.length * progress);

    canvas.drawPath(extract, prog);
  }

  @override
  bool shouldRepaint(covariant _OvalPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
