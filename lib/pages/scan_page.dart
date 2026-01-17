import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/ocr_service.dart';
import 'ocr_result_page.dart';
import 'ocr_history_page.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  CameraController? controller;
  List<CameraDescription> cameras = [];
  File? _selectedFile;
  XFile? _webImage;
  final ImagePicker picker = ImagePicker();
  final OcrService _ocrService = OcrService();

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> initCamera() async {
    try {
      if (!kIsWeb) {
        var status = await Permission.camera.request();
        if (!status.isGranted) return;
      }

      cameras = await availableCameras();
      if (cameras.isEmpty) return;

      controller = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Camera init error: $e");
    }
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        if (kIsWeb) {
          _webImage = image;
        } else {
          _selectedFile = File(image.path);
        }
      });
    }
  }

  Future<void> processImage() async {
    if (_selectedFile == null && _webImage == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final result = await _ocrService.translateImage(
        imageFile: _selectedFile,
        webImage: _webImage,
      );

      setState(() {
        _isProcessing = false;
      });

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OcrResultPage(
              ocrResult: result,
              imageFile: _selectedFile,
              webImage: _webImage,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isProcessing) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 20),
              Text(
                "Memproses Gambar...",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    final bool cameraReady =
        (controller != null && controller!.value.isInitialized);
    final bool hasImage = (_selectedFile != null || _webImage != null);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Background Content (Camera or Image)
          if (!hasImage && cameraReady)
            Positioned.fill(child: CameraPreview(controller!))
          else if (hasImage)
            Positioned.fill(child: _previewSelectedImage())
          else
            const Center(child: CircularProgressIndicator(color: Colors.white)),

          // 2. Overlay Top UI
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _circleIconButton(
                  icon: Icons.arrow_back,
                  onPressed: () => Navigator.pop(context),
                ),
                if (hasImage)
                  _circleIconButton(
                    icon: Icons.close,
                    onPressed: () => setState(() {
                      _selectedFile = null;
                      _webImage = null;
                    }),
                  )
                else
                  const SizedBox(width: 48),
                _circleIconButton(
                  icon: Icons.history,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OcrHistoryPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // 3. Overlay Bottom Controls
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                if (hasImage)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: processImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        icon: const Icon(Icons.translate),
                        label: const Text(
                          "PROSES GAMBAR",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Gallery Option
                      _actionButton(
                        icon: Icons.photo_library,
                        label: "Galeri",
                        onPressed: pickImage,
                      ),
                      // Capture Button
                      GestureDetector(
                        onTap: () async {
                          if (!cameraReady) return;
                          try {
                            final XFile picture = await controller!
                                .takePicture();
                            setState(() {
                              if (kIsWeb) {
                                _webImage = picture;
                              } else {
                                _selectedFile = File(picture.path);
                              }
                            });
                          } catch (e) {
                            debugPrint("Capture error: $e");
                          }
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: Center(
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Switch Camera
                      _actionButton(
                        icon: Icons.flip_camera_ios,
                        label: "Balik",
                        onPressed: _toggleCamera,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleCamera() async {
    if (cameras.length < 2) return;
    final lensDirection = controller!.description.lensDirection;
    CameraDescription newDescription = cameras.firstWhere(
      (c) => lensDirection == CameraLensDirection.back
          ? c.lensDirection == CameraLensDirection.front
          : c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );
    await controller!.dispose();
    controller = CameraController(
      newDescription,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await controller!.initialize();
    if (mounted) setState(() {});
  }

  Widget _previewSelectedImage() {
    if (kIsWeb && _webImage != null) {
      return Image.network(_webImage!.path, fit: BoxFit.contain);
    } else if (!kIsWeb && _selectedFile != null) {
      return Image.file(_selectedFile!, fit: BoxFit.contain);
    }
    return const Center(
      child: Icon(Icons.image, size: 80, color: Colors.white),
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return CircleAvatar(
      backgroundColor: Colors.black45,
      radius: 24,
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 24),
        onPressed: onPressed,
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _circleIconButton(icon: icon, onPressed: onPressed),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
