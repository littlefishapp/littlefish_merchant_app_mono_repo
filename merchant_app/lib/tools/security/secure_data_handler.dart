import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:math';

class SecureDataHandler {
  final Uint8List _storageKey; // Key for secure storage
  final Uint8List _storageIV; // IV for secure storage
  static const _secureStorage = FlutterSecureStorage();

  SecureDataHandler._(this._storageKey, this._storageIV);

  static Future<SecureDataHandler> create() async {
    final storageKey = await _generateKey(); // 256-bit key
    final storageIV = await _generateIV(); // 128-bit IV
    final handler = SecureDataHandler._(storageKey, storageIV);
    await handler._storeKeyAndIV(); // Store the key and IV in secure storage
    return handler;
  }

  /// Encrypts a string using AES-CBC
  Future<String> encryptData(String data) async {
    if (data.isEmpty) {
      return '';
    }

    Map<String, Uint8List?> keyAndIv = await _retrieveKeyAndIV();
    final Uint8List key = keyAndIv['key']!;
    final Uint8List iv = keyAndIv['iv']!;
    final cipher = CBCBlockCipher(AESEngine())
      ..init(true, ParametersWithIV(KeyParameter(key), iv));

    final paddedData = _pad(Uint8List.fromList(utf8.encode(data)));
    final encryptedBytes = _processBlocks(cipher, paddedData);

    // Clear sensitive data from memory
    key.fillRange(0, key.length, 0);
    iv.fillRange(0, iv.length, 0);
    // Clear sensitive data from memory
    keyAndIv.clear();

    return base64.encode(encryptedBytes);
  }

  /// Decrypts a string using AES-CBC
  Future<String> decryptData(String encrypted) async {
    if (encrypted.isEmpty) {
      return '';
    }

    Map<String, Uint8List?> keyAndIv = await _retrieveKeyAndIV();
    final Uint8List key = keyAndIv['key']!;
    final Uint8List iv = keyAndIv['iv']!;

    final cipher = CBCBlockCipher(AESEngine())
      ..init(false, ParametersWithIV(KeyParameter(key), iv));
    final encryptedBytes = base64.decode(encrypted);
    final decryptedBytes = _unpad(_processBlocks(cipher, encryptedBytes));

    // Clear sensitive data from memory
    key.fillRange(0, key.length, 0);
    iv.fillRange(0, iv.length, 0);
    // Clear sensitive data from memory
    keyAndIv.clear();

    return utf8.decode(decryptedBytes);
  }

  /// Encrypts a Uint8List using AES-CBC
  Future<Uint8List> encryptUint8List(Uint8List data) async {
    Map<String, Uint8List?> keyAndIv = await _retrieveKeyAndIV();
    final Uint8List key = keyAndIv['key']!;
    final Uint8List iv = keyAndIv['iv']!;

    final cipher = CBCBlockCipher(AESEngine())
      ..init(false, ParametersWithIV(KeyParameter(key), iv));
    final paddedData = _pad(data);

    // Clear sensitive data from memory
    key.fillRange(0, key.length, 0);
    iv.fillRange(0, iv.length, 0);
    // Clear sensitive data from memory
    keyAndIv.clear();

    return _processBlocks(cipher, paddedData);
  }

  /// Decrypts a Uint8List using AES-CBC
  Future<Uint8List> decryptUint8List(Uint8List encrypted) async {
    Map<String, Uint8List?> keyAndIv = await _retrieveKeyAndIV();
    final Uint8List key = keyAndIv['key']!;
    final Uint8List iv = keyAndIv['iv']!;

    final cipher = CBCBlockCipher(AESEngine())
      ..init(false, ParametersWithIV(KeyParameter(key), iv));
    final decryptedBytes = _processBlocks(cipher, encrypted);

    // Clear sensitive data from memory
    key.fillRange(0, key.length, 0);
    iv.fillRange(0, iv.length, 0);
    // Clear sensitive data from memory
    keyAndIv.clear();

    return _unpad(decryptedBytes);
  }

  /// Pads data to be a multiple of 16 bytes (PKCS7 padding)
  Uint8List _pad(Uint8List data) {
    final padLength = 16 - (data.length % 16);
    return Uint8List.fromList([...data, ...List.filled(padLength, padLength)]);
  }

  /// Removes PKCS7 padding
  Uint8List _unpad(Uint8List data) {
    final padLength = data.last;
    return data.sublist(0, data.length - padLength);
  }

  /// Processes data block by block
  Uint8List _processBlocks(BlockCipher cipher, Uint8List input) {
    final output = Uint8List(input.length);
    for (int i = 0; i < input.length; i += cipher.blockSize) {
      cipher.processBlock(input, i, output, i);
    }
    return output;
  }

  /// Generates a random 256-bit AES key
  static Future<Uint8List> _generateKey() async {
    final random = Random.secure();
    final key = List<int>.generate(
      32,
      (_) => random.nextInt(256),
    ); // 256-bit key
    return Uint8List.fromList(key);
  }

  /// Generates a random 128-bit IV
  static Future<Uint8List> _generateIV() async {
    final random = Random.secure();
    final iv = List<int>.generate(16, (_) => random.nextInt(256)); // 128-bit IV
    return Uint8List.fromList(iv);
  }

  /// Stores the AES key and IV in secure storage
  Future<void> _storeKeyAndIV() async {
    await _secureStorage.write(
      key: utf8.decode(_storageKey),
      value: base64.encode(await _generateKey()),
    );
    await _secureStorage.write(
      key: utf8.decode(_storageIV),
      value: base64.encode(await _generateIV()),
    );
  }

  /// Retrieves the AES key and IV from secure storage
  Future<Map<String, Uint8List?>> _retrieveKeyAndIV() async {
    final key = await _secureStorage.read(key: utf8.decode(_storageKey));
    final iv = await _secureStorage.read(key: utf8.decode(_storageIV));
    return {
      'key': key != null ? base64.decode(key) : null,
      'iv': iv != null ? base64.decode(iv) : null,
    };
  }

  /// Clears the AES key and IV from secure storage
  Future<void> clearSecureStorage() async {
    await _secureStorage.delete(key: utf8.decode(_storageKey));
    await _secureStorage.delete(key: utf8.decode(_storageIV));
  }

  /// Clears a Uint8List variable by filling it with zeros
  void clearUint8List(Uint8List data) {
    data.fillRange(0, data.length, 0);
  }

  /// Clears a String variable by dereferencing it
  void clearString(String? data) {
    data = null;
  }
}
