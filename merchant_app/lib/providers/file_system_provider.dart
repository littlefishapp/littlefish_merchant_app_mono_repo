// Dart imports:
import 'dart:io';

// Flutter imports:

// Package imports:
import 'package:path_provider/path_provider.dart';

class FileSystemProvider {
  static final FileSystemProvider instance = FileSystemProvider._internal();

  FileSystemProvider._internal();

  factory FileSystemProvider() => instance;

  static Directory? cacheDirectory;

  static String? get cacheDirectoryPath {
    return cacheDirectory?.path;
  }

  static Future<void> initialize() async {
    cacheDirectory = await getTemporaryDirectory();
  }

  Future<File?> saveFile({
    required String category,
    required name,
    required File? file,
  }) async {
    var directory = await getTemporaryDirectory();

    var categoryFolder = Directory('${directory.path}/$category');
    if (!await categoryFolder.exists()) {
      await categoryFolder.create();
    }
    var categoryFile = File('${categoryFolder.path}/$name');

    if (await categoryFile.exists()) await categoryFile.delete();

    var result = await file!.copy(categoryFile.path);

    return result;
  }
}
