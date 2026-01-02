// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter/services.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core/storage/littlefish_storage_service.dart';
import 'package:littlefish_core/storage/models/storage_reference.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/providers/permissions_provider.dart';
import 'package:littlefish_merchant/tools/exceptions/common_exceptions.dart';

import '../common/presentaion/components/dialogs/common_dialogs.dart';
import '../common/presentaion/components/common_divider.dart';

class FileManager {
  LittleFishCore core = LittleFishCore.instance;

  LoggerService get logger => core.get<LoggerService>();

  LittleFishStorageService get storageService =>
      core.get<LittleFishStorageService>();

  Future<StorageReference?> chooseAndUploadImage(
    context, {
    required String? itemId,
    required String sectionId,
    required String? groupId,
    Map<String, String>? metaData,
  }) async {
    try {
      var imageSource = await selectFileSource(context);

      if (imageSource == null || groupId == null || itemId == null) return null;

      var imageResult = await uploadImage(
        groupId: groupId ?? '',
        itemId: itemId ?? '',
        sectionId: sectionId,
        source: imageSource ?? ImageSource.gallery,
        metaData:
            metaData ??
            {'type': 'imagery', 'id': itemId ?? '', 'store': groupId ?? ''},
      );

      return imageResult;
    } catch (error) {
      reportCheckedError(error);
      rethrow;
    }
  }

  Future<bool> isFileTypeAllowed(
    XFile selectedImage,
    BuildContext context,
  ) async {
    List<String> allowedFileTypes =
        AppVariables.store!.state.environmentSettings!.allowedFileTypes!;
    String imagePath = selectedImage.path;
    String extension = imagePath.split('.').last.toLowerCase();

    if (!allowedFileTypes.contains(extension)) {
      String filetypes = allowedFileTypes.join('/');
      showMessageDialog(
        context,
        'Please select a $filetypes image',
        LittleFishIcons.error,
      );
      return false;
    }

    return true;
  }

  Future<bool> checkAccess() async {
    var storagePermissionGranted = await PermissionsProvider.instance
        .hasPermission(Permission.storage);
    var photos = await PermissionsProvider.instance.hasPermission(
      Permission.photos,
    );
    var videos = await PermissionsProvider.instance.hasPermission(
      Permission.videos,
    );
    var camera = await PermissionsProvider.instance.hasPermission(
      Permission.camera,
    );

    if (storagePermissionGranted == true ||
        photos == true ||
        videos == true ||
        camera == true) {
      return true;
    } else {
      if (Platform.isIOS) {
        // var res = await PermissionsProvider.instance
        //     .requestPermission(Permission.storage);
        var perm = await PermissionsProvider.instance.hasPermission(
          Permission.storage,
        );
        return perm;
      }

      final deviceInfo = await DeviceInfoPlugin().androidInfo;

      if (deviceInfo.version.sdkInt > 29) {
        // Check for photos permission
        var photosPerm = await PermissionsProvider.instance.hasPermission(
          Permission.photos,
        );

        // Check for video permission
        var videoPerm = await PermissionsProvider.instance.hasPermission(
          Permission.videos,
        );

        // Check for camera permission
        var cameraPerm = await PermissionsProvider.instance.hasPermission(
          Permission.camera,
        );

        // Combine the results of all permission checks
        return photosPerm && videoPerm && cameraPerm;
      } else {
        // var res = await PermissionsProvider.instance
        //     .requestPermission(Permission.storage);
        var perm = await PermissionsProvider.instance.hasPermission(
          Permission.storage,
        );
        return perm;
      }
    }
  }

  Future<StorageReference?> uploadImage({
    required ImageSource source,
    required String groupId,
    required String sectionId,
    required String itemId,
    Map<String, String>? metaData,
  }) async {
    await checkAccess();
    //important to have this in a single place
    var imgPicker = ImagePicker();
    var selectedImage = await imgPicker.pickImage(source: source);

    if (selectedImage == null) return null;

    try {
      var result = await FileManager().uploadFile(
        file: File(selectedImage.path),
        businessId: groupId,
        category: sectionId,
        id: itemId,
        businessName: itemId,
      );

      return result;
    } on PlatformException catch (e) {
      logger.warning(
        this,
        'An error occurred while uploading image, platform exception: ${e.code}: ${e.message}',
        error: e,
        stackTrace: StackTrace.current,
      );

      rethrow;
    } catch (error) {
      logger.error(
        this,
        'An unexpected occurred while uploading image: $error',
        error: error,
        stackTrace: StackTrace.current,
      );
      rethrow;
    }
  }

  Future<StorageReference?> uploadImageUsingStorageService({
    required ImageSource source,
    required String groupId,
    required String sectionId,
    required String itemId,
    Map<String, String>? metaData,
  }) async {
    await checkAccess();
    //important to have this in a single place
    var imgPicker = ImagePicker();
    var selectedImage = await imgPicker.pickImage(source: source);

    if (selectedImage == null) return null;

    try {
      var resultNew = await storageService.uploadFile(
        businessId: groupId,
        fileCategory: sectionId,
        folder: 'images',
        fileId: itemId,
        file: File(selectedImage.path),
        metadata: const {},
      );

      logger.debug(
        this,
        'file uploaded using new service: ${resultNew.fullPath}',
      );

      return resultNew;
    } on PlatformException catch (e) {
      logger.warning(
        this,
        'An error occurred while uploading image, platform exception: ${e.code}: ${e.message}',
        error: e,
        stackTrace: StackTrace.current,
      );

      rethrow;
    } catch (error) {
      logger.error(
        this,
        'An unexpected occurred while uploading image: $error',
        error: error,
        stackTrace: StackTrace.current,
      );
      rethrow;
    }
  }

  Future<String> getDownloadFilePath(String filename) async {
    await checkAccess();
    var directoryPath = '${await getLocalDirectory()}/downloads';

    var directory = Directory(directoryPath);

    bool exists = await directory.exists();

    if (!exists) await directory.create();

    var filePath = '$directoryPath/$filename';

    // var file = File(filePath);

    // exists = await file.exists();

    // if (exists) await file.delete();

    return filePath;
  }

  Future<StorageReference> uploadFile({
    required File file,
    required String businessId,
    required String category,
    required String id,
    required String businessName,
  }) async {
    if (businessId.isEmpty) {
      throw ManagedException(message: 'upload cancelled, businessId is null');
    }

    try {
      final uploadResult = await storageService.uploadFile(
        businessId: businessId,
        fileCategory: category,
        fileId: id,
        folder: 'images',
        file: file,
        metadata: {},
      );

      logger.debug(
        this,
        'file uploaded using new service: ${uploadResult.fullPath}',
      );

      return uploadResult;
    } catch (e) {
      logger.error(
        this,
        'An error occurred while uploading file: $e',
        error: e,
        stackTrace: StackTrace.current,
      );

      rethrow;
    }
  }

  Future<String> getLocalDirectory() async {
    final directory = await (getExternalStorageDirectory());
    return directory!.path;
  }

  Future<ImageSource?> selectFileSource(BuildContext context) async {
    var res = await checkAccess();
    if (res == false) {
      PermissionsProvider permProvider = PermissionsProvider();
      await permProvider.requestPermissions([
        Permission.storage,
        Permission.camera,
        Permission.photos,
        Permission.videos,
      ]);
      res = await checkAccess();
    }
    ImageSource imgSource = ImageSource.camera;
    if (res == true) {
      return showModalBottomSheet<ImageSource>(
        elevation: 0,
        // removed ignore: use_build_context_synchronously
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (ctx) => SafeArea(
          top: false,
          bottom: true,
          child: SizedBox(
            height: 180,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                const CommonDivider(height: 0.5),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25.0),
                      ),
                    ),
                    tileColor: Colors.transparent,
                    title: context.labelLarge(
                      'Camera',
                      isBold: true,
                      alignLeft: true,
                    ),
                    subtitle: context.labelMedium(
                      'Take a photo',
                      alignLeft: true,
                    ),
                    leading: const SizedBox(
                      height: double.infinity,
                      child: Icon(Icons.camera_alt_outlined),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_outlined),
                    onTap: () async {
                      imgSource = ImageSource.camera;
                      Navigator.of(context).pop(ImageSource.camera);
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25.0),
                      ),
                    ),
                    tileColor: Colors.transparent,
                    title: context.labelLarge(
                      'Gallery',
                      isBold: true,
                      alignLeft: true,
                    ),
                    subtitle: context.labelMedium(
                      'Select an image from your photos',
                      alignLeft: true,
                    ),
                    leading: const SizedBox(
                      height: double.infinity,
                      child: Icon(Icons.photo_library_outlined),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_outlined),
                    onTap: () {
                      imgSource = ImageSource.gallery;
                      Navigator.of(context).pop(ImageSource.gallery);
                    },
                  ),
                ),
                const CommonDivider(),
              ],
            ),
          ),
        ),
      );
    } else {
      // removed ignore: use_build_context_synchronously
      showPermissionDialog(context, Permission.storage);
      // await showMessageDialog(
      //   context,
      //   'Permission Denied',
      //   LittleFishIcons.error,
      // );
    }

    return imgSource;
  }
}

class ImageHelper {
  String? address, imageUrl;
  ImageHelper({this.address, this.imageUrl});
}
