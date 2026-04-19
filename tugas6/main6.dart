import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error mengambil kamera: $e');
  }

  runApp(
    const MaterialApp(
      home: HalamanUtamaKamera(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class HalamanUtamaKamera extends StatefulWidget {
  const HalamanUtamaKamera({super.key});

  @override
  State<HalamanUtamaKamera> createState() => _HalamanUtamaKameraState();
}

class _HalamanUtamaKameraState extends State<HalamanUtamaKamera> {
  String? _imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplikasi Kamera API'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_imagePath != null)
              Container(
                width: 300,
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepPurple, width: 3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Image.file(File(_imagePath!), fit: BoxFit.cover),
                ),
              )
            else
              const Text(
                'Belum ada foto yang diambil.',
                style: TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () async {
                final path = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LayarAmbilFoto(),
                  ),
                );

                if (path != null) {
                  setState(() {
                    _imagePath = path;
                  });
                }
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Buka Kamera'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LayarAmbilFoto extends StatefulWidget {
  const LayarAmbilFoto({super.key});

  @override
  State<LayarAmbilFoto> createState() => _LayarAmbilFotoState();
}

class _LayarAmbilFotoState extends State<LayarAmbilFoto> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  int _cameraIndex = 0;

  @override
  void initState() {
    super.initState();

    if (cameras.isNotEmpty) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    _controller = CameraController(cameras[_cameraIndex], ResolutionPreset.max);

    _initializeControllerFuture = _controller!.initialize().then((_) async {
      await _controller!.setFocusMode(FocusMode.auto);
      await _controller!.setExposureMode(ExposureMode.auto);
    });

    setState(() {});
  }

  Future<void> _switchCamera() async {
    if (cameras.length < 2) return;

    _cameraIndex = _cameraIndex == 0 ? 1 : 0;

    await _controller?.dispose();

    await _initCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambil Foto'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              _controller != null) {
            return Stack(
              children: [
                Positioned.fill(
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: CameraPreview(_controller!),
                  ),
                ),

                // 🔄 Tombol flip kamera
                Positioned(
                  top: 40,
                  right: 20,
                  child: IconButton(
                    icon: const Icon(
                      Icons.flip_camera_android,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: _switchCamera,
                  ),
                ),

                // 📸 Tombol capture
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      child: const Icon(Icons.camera),
                      onPressed: () async {
                        try {
                          await _initializeControllerFuture;

                          final XFile image = await _controller!.takePicture();

                          if (!mounted) return;

                          Navigator.pop(context, image.path);
                        } catch (e) {
                          print('Error saat mengambil gambar: $e');
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (cameras.isEmpty) {
            return const Center(child: Text("Kamera tidak ditemukan"));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}
