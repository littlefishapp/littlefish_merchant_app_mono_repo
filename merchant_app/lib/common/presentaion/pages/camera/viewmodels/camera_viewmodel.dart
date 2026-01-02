// Dart imports:
import 'dart:async';

// Package imports:
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

// Project imports:
import 'package:littlefish_merchant/models/shared/common_view_model.dart';

class CameraViewModel extends CommonViewModel {
  CameraViewModel({this.lensDirection = CameraLensDirection.back});

  List<CameraDescription>? cameras;

  bool get hasCamera {
    return cameras != null && cameras!.isNotEmpty;
  }

  CameraLensDirection lensDirection;

  CameraDescription? get selectedCamera {
    return cameras?.firstWhere((c) => c.lensDirection == lensDirection);
  }

  @override
  Future<void> populate({bool refresh = false}) async {
    isLoading = true;
    try {
      cameras = await availableCameras();
    } on CameraException catch (e) {
      debugPrint(e.toString());
      rethrow;
    } finally {
      isLoading = false;
    }
  }
}
