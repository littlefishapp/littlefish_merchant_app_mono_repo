import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

enum ScreenMode { liveFeed, gallery }

class CameraView extends StatefulWidget {
  const CameraView({
    Key? key,
    required this.title,
    this.customWidget,
    required this.onInputImageAvailable,
    this.initialDirection = CameraLensDirection.back,
    this.enabelZoomSlider = false,
    this.onCameraFeedReady,
  }) : super(key: key);

  final String title;
  final Widget? customWidget;
  final Function(InputImage inputImage) onInputImageAvailable;
  final VoidCallback? onCameraFeedReady;
  final CameraLensDirection initialDirection;
  final bool enabelZoomSlider;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  final _mode = ScreenMode.liveFeed;
  late CameraController _controller;
  File? _image;
  late ImagePicker _imagePicker;
  int _cameraIndex = 0;
  double zoomLevel = 0.0;
  double minZoomLevel = 0.0;
  double maxZoomLevel = 0.0;
  bool _isCameraInitialized = false;
  bool _isTorchOn = false; // Local torch state

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
    for (var i = 0; i < cameras.length; i++) {
      if (cameras[i].lensDirection == widget.initialDirection) {
        _cameraIndex = i;
      }
    }
    _isTorchOn = false;
    _startLiveFeed();
  }

  @override
  void dispose() {
    debugPrint('### CameraView dispose');
    _stopLiveFeed();
    super.dispose();
  }

  Future<void> _startLiveFeed() async {
    debugPrint('### CameraView startLiveFeed entry');
    final camera = cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.low,
      fps: 10,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.yuv420
          : ImageFormatGroup.bgra8888,
    );
    debugPrint('### CameraView startLiveFeed init cntrl');
    try {
      await _controller.initialize();
      minZoomLevel = await _controller.getMinZoomLevel();
      zoomLevel = minZoomLevel;
      maxZoomLevel = await _controller.getMaxZoomLevel();

      await _updateTorchState();

      await _controller.startImageStream(_onCameraImageAvailable);
      if (widget.onCameraFeedReady != null) {
        widget.onCameraFeedReady!();
      }
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('### CameraView startLiveFeed error: $e');
      debugPrint('### CameraView startLiveFeed error: $e');
    }
    debugPrint('### CameraView startLiveFeed exit');
  }

  Future<void> _updateTorchState() async {
    if (!_isCameraInitialized) return;
    try {
      await _controller.setFlashMode(
        _isTorchOn ? FlashMode.torch : FlashMode.off,
      );
    } catch (e) {
      debugPrint('### CameraView updateTorchState error: $e');
    }
  }

  Future<void> toggleTorch() async {
    if (!_isCameraInitialized) return;
    try {
      _isTorchOn = !_isTorchOn;
      await _controller.setFlashMode(
        _isTorchOn ? FlashMode.torch : FlashMode.off,
      );
      setState(() {}); // Update UI to reflect torch icon change
    } catch (e) {
      debugPrint('### CameraView toggleTorch error: $e');
    }
  }

  Future<void> _stopLiveFeed() async {
    debugPrint('### CameraView stopLiveFeed entry');
    if (_isCameraInitialized) {
      try {
        await _controller.stopImageStream();
      } catch (e) {
        debugPrint('### CameraView stopImageStream error: $e');
      }
      try {
        await _controller.dispose();
      } catch (e) {
        debugPrint('### CameraView dispose controller error: $e');
      }
    }
    debugPrint('### CameraView stopLiveFeed exit');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('### CameraView build entry');
    if (!_isCameraInitialized) {
      return const AppProgressIndicator();
    }
    return _body();
  }

  Widget _body() {
    Widget body;
    if (_mode == ScreenMode.liveFeed) {
      body = _liveFeedBody();
    } else {
      body = _galleryBody();
    }
    return body;
  }

  Widget _liveFeedBody() {
    if (_controller.value.isInitialized == false) {
      debugPrint('### CameraView liveFeedBody() cntl not init');
      return const SizedBox.shrink();
    }
    debugPrint('### CameraView liveFeedBody() -> cameraPreview()');
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controller),
          if (widget.customWidget != null) widget.customWidget!,
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: Icon(
                _isTorchOn ? Icons.flash_on : Icons.flash_off,
                color: Colors.white,
                size: 24,
              ),
              onPressed: toggleTorch,
            ),
          ),
          _zoomControl(),
        ],
      ),
    );
  }

  Widget _zoomControl() {
    return widget.enabelZoomSlider
        ? Positioned(
            bottom: 100,
            left: 50,
            right: 50,
            child: Slider(
              value: zoomLevel,
              min: minZoomLevel,
              max: maxZoomLevel,
              onChanged: (newSliderValue) {
                setState(() {
                  zoomLevel = newSliderValue;
                  _controller.setZoomLevel(zoomLevel);
                });
              },
              divisions: (maxZoomLevel - 1).toInt() < 1
                  ? null
                  : (maxZoomLevel - 1).toInt(),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _galleryBody() {
    return ListView(
      shrinkWrap: true,
      children: [
        _image != null
            ? SizedBox(
                height: 400,
                width: 400,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image.file(_image!),
                    if (widget.customWidget != null) widget.customWidget!,
                  ],
                ),
              )
            : const Icon(Icons.image, size: 200),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton(
            child: const Text(
              'From Gallery',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => _getImage(ImageSource.gallery),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton(
            child: const Text(
              'Take a picture',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => _getImage(ImageSource.camera),
          ),
        ),
      ],
    );
  }

  Future _getImage(ImageSource source) async {
    final pickedFile = await _imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      _processXFile(pickedFile);
    } else {
      debugPrint('No image selected.');
    }
    setState(() {});
  }

  void _processXFile(XFile xFile) {
    setState(() {
      _image = File(xFile.path);
    });
    final inputImage = InputImage.fromFilePath(xFile.path);
    widget.onInputImageAvailable(inputImage);
  }

  void _onCameraImageAvailable(CameraImage image) {
    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage != null) {
        widget.onInputImageAvailable(inputImage);
      }
    } catch (e) {
      debugPrint('### CameraView onCameraImageAvailable error: $e');
    }
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    // Get image dimensions
    final Size imageSize = Size(
      image.width.toDouble(),
      image.height.toDouble(),
    );

    // Get camera details
    final camera = cameras[_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;

    // Calculate rotation (unchanged)
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[_controller.value.deviceOrientation];
      if (rotationCompensation == null) {
        debugPrint(
          '### CameraView _inputImageFromCameraImage rotation is null',
        );
        return null;
      }
      if (camera.lensDirection == CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) {
      debugPrint('### CameraView _inputImageFromCameraImage rotation is null');
      return null;
    }

    // Verify image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null ||
        (format != InputImageFormat.yuv_420_888 &&
            format != InputImageFormat.bgra8888)) {
      debugPrint(
        '### CameraView _inputImageFromCameraImage unsupported format: $format',
      );
      return null;
    }

    // Handle bytes based on platform/format
    Uint8List? imageBytes;
    int? bytesPerRow;
    InputImageFormat? mlKitFormat;

    if (Platform.isIOS || format == InputImageFormat.bgra8888) {
      // iOS: Single plane BGRA
      final plane = image.planes.first;
      imageBytes = plane.bytes;
      bytesPerRow = plane.bytesPerRow;
      mlKitFormat = InputImageFormat.bgra8888;
    } else {
      // Android: YUV_420_888 -> Convert to NV21
      imageBytes = _yuv420ToNv21(image);
      bytesPerRow = image.width; // NV21 has no padding
      mlKitFormat = InputImageFormat.nv21;
    }

    final inputImageMetadata = InputImageMetadata(
      size: imageSize,
      rotation: rotation,
      format: mlKitFormat,
      bytesPerRow: bytesPerRow,
    );

    return InputImage.fromBytes(
      bytes: imageBytes,
      metadata: inputImageMetadata,
    );
  }

  // Helper to convert YUV_420_888 to NV21 (add this method to the class)
  Uint8List _yuv420ToNv21(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final Plane yPlane = image.planes[0];
    final Plane uPlane = image.planes[1];
    final Plane vPlane = image.planes[2];

    final Uint8List yBuffer = yPlane.bytes;
    final Uint8List uBuffer = uPlane.bytes;
    final Uint8List vBuffer = vPlane.bytes;

    final int ySize = yBuffer.lengthInBytes;
    final int uvSize = (width * height) ~/ 2; // For 4:2:0 subsampling
    final Uint8List nv21 = Uint8List(ySize + uvSize);

    // Copy Y plane (with potential padding, but setRange handles it)
    nv21.setRange(0, ySize, yBuffer);

    // Interleave UV for NV21 (VU order, subsampled 4:2:0)
    int uvIndex = ySize;
    final int uvPixelStrideU = uPlane.bytesPerPixel ?? 1;
    final int uvPixelStrideV = vPlane.bytesPerPixel ?? 1;
    final int uvRowStrideU = uPlane.bytesPerRow;
    final int uvRowStrideV = vPlane.bytesPerRow;

    for (int j = 0; j < height ~/ 2; j++) {
      for (int i = 0; i < width ~/ 2; i++) {
        final int uvIndexU = (j * uvRowStrideU) + (i * uvPixelStrideU);
        final int uvIndexV = (j * uvRowStrideV) + (i * uvPixelStrideV);

        // Bounds check to handle padding/variable strides
        if (uvIndexU < uBuffer.lengthInBytes &&
            uvIndexV < vBuffer.lengthInBytes) {
          nv21[uvIndex++] = vBuffer[uvIndexV]; // V first in NV21
          nv21[uvIndex++] = uBuffer[uvIndexU]; // Then U
        }
      }
    }

    return nv21;
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };
}
