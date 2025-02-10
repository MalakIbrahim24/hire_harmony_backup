import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class PotionMaker {
  // Singleton instance
  static final PotionMaker _instance = PotionMaker._internal();

  late final encrypt.Key _aesKey;
  final encrypt.IV _iv = encrypt.IV.fromLength(16);

  // ✅ Private Constructor: Initializes the AES key correctly
  PotionMaker._internal() {
    String rawKey =
        fixKeyLength('correct_32_byte_key_fixed______'); // Ensure 32 bytes
    _aesKey = encrypt.Key.fromUtf8(rawKey);
    print("🟢 AES Key Length: ${_aesKey.bytes.length}"); // Debugging
  }

  // ✅ Factory constructor returns the singleton instance
  factory PotionMaker() {
    return _instance;
  }

  /// 🛠 Ensure key is exactly 32 bytes
  String fixKeyLength(String key) {
    if (key.length > 32) {
      return key.substring(0, 32); // Trim excess characters
    } else if (key.length < 32) {
      return key.padRight(32, '0'); // Pad with zeros if too short
    }
    return key;
  }

  /// 🔑 Generate a random salt (16 bytes)
  String generateSalt() {
    final Random random = Random.secure();
    final List<int> saltBytes = List.generate(16, (_) => random.nextInt(256));
    return base64Encode(saltBytes);
  }

  /// 🔑 Generate a unique secret key for HMAC (32 bytes)
  String generateSecretKey() {
    final Random random = Random.secure();
    final List<int> keyBytes = List.generate(32, (_) => random.nextInt(256));
    return base64Encode(keyBytes);
  }

  /// 🔒 Hash a password with a salt using SHA-256
  String hashPassword(String password, String salt) {
    var bytes = utf8.encode(salt + password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// 🔐 Generate HMAC using SHA-256 and a secret key
  String generateHmac(String message, String secretKey) {
    var key = utf8.encode(secretKey);
    var bytes = utf8.encode(message);
    var hmac = Hmac(sha256, key);
    var digest = hmac.convert(bytes);
    return digest.toString();
  }

  /// 🔒 Encrypt the secret key using AES-256
  String encryptSecretKey(String secretKey) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_aesKey,
        mode: encrypt.AESMode.cbc)); // Explicitly set CBC mode
    final encrypted = encrypter.encrypt(secretKey, iv: _iv);
    return encrypted.base64;
  }

  /// 🔓 Decrypt the secret key using AES-256
  String decryptSecretKey(String encryptedKey) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_aesKey,
        mode: encrypt.AESMode.cbc)); // Explicitly set CBC mode
    return encrypter.decrypt64(encryptedKey, iv: _iv);
  }

  /// 🔎 Verify a password using stored salt, HMAC, and secret key
  bool verifyPassword(String inputPassword, String storedSalt,
      String storedHmac, String storedSecretKey) {
    String hashedInputPassword = hashPassword(inputPassword, storedSalt);
    String newHmac = generateHmac(hashedInputPassword, storedSecretKey);
    return newHmac == storedHmac;
  }
}
