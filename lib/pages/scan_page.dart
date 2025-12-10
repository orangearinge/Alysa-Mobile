import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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

  bool showCamera = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> initCamera() async {
    if (kIsWeb) {
      cameras = await availableCameras();

      controller = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await controller!.initialize();
      setState(() {});
      return;
    }

    var status = await Permission.camera.request();
    if (!status.isGranted) return;

    cameras = await availableCameras();

    controller = CameraController(
      cameras.first,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await controller!.initialize();
    setState(() {});
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (kIsWeb) {
        _webImage = image;
      } else {
        _selectedFile = File(image.path);
      }
      setState(() {});
    }
  }

  Widget _imagePreview() {
    Widget content;

    if (kIsWeb && _webImage != null) {
      content = Image.network(_webImage!.path, fit: BoxFit.cover);
    } else if (!kIsWeb && _selectedFile != null) {
      content = Image.file(_selectedFile!, fit: BoxFit.cover);
    } else {
      content = const Icon(Icons.image, size: 80, color: Colors.grey);
    }

    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: content,
      ),
    );
  }

  Widget _button(String text, IconData icon, VoidCallback onPressed,
      {Color? color, Color? textColor}) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.blue,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: Icon(icon),
        label: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool cameraReady =
        (controller != null && controller!.value.isInitialized);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan / Upload Image"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _imagePreview(),

              const SizedBox(height: 16),

              _button("Upload Gambar", Icons.upload, pickImage),

              const SizedBox(height: 10),

              _button(
                "Buka Kamera",
                Icons.camera_alt,
                () async {
                  showCamera = true;
                  await initCamera();
                  setState(() {});
                },
                color: Colors.white,
                textColor: Colors.blue,
              ),

              const SizedBox(height: 20),

              // Camera Preview
              if (showCamera && cameraReady)
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CameraPreview(controller!),
                        ),
                      ),

                      const SizedBox(height: 12),

                      _button("Ambil Foto", Icons.camera, () async {
                        final XFile picture =
                            await controller!.takePicture();

                        if (kIsWeb) {
                          _webImage = picture;
                        } else {
                          _selectedFile = File(picture.path);
                        }

                        showCamera = false;
                        setState(() {});
                      }),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
