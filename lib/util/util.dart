
import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String aesDecrypt(String encryptedText, String key) {
  // Check if the input is null or empty
  if (encryptedText == null || encryptedText.isEmpty) {
    return ''; // Return a default value or message
  }

  try {
    final keyBytes = Key.fromUtf8(key); // Ensure your key length matches AES requirements
    final iv = IV.fromLength(16);       // ECB mode doesn't require IV, but you can set a dummy one
    final encrypter = Encrypter(AES(keyBytes, mode: AESMode.ecb, padding: 'PKCS7'));

    // Perform decryption
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  } catch (e) {
    return ''; // Handle decryption failure
  }
}
// AES Encryption function
String encryptAES(String plainText, String key) {
  // Check if the input plainText is null or empty
  if (plainText == null || plainText.isEmpty) {
    return ''; // Return a default value or error message
  }

  // Check if the key is null, empty, or invalid
  if (key == null || key.isEmpty || key.length != 16) {
    return ''; // Check for a valid key
  }

  try {
    // Convert the key and plain text to bytes
    final keyBytes = Key.fromUtf8(key); // Ensure key length matches AES requirements
    final iv = IV.fromLength(16);       // Initialization Vector with fixed length (ECB doesn't need it)

    // Use AES algorithm with ECB mode and PKCS7 padding
    final encrypter = Encrypter(AES(keyBytes, mode: AESMode.ecb, padding: 'PKCS7'));

    // Encrypt the plain text
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64; // Return encrypted text as Base64
  } catch (e) {
    return ''; // Handle encryption failure
  }
}

String yourDBKey = dotenv.env["YOUR_DB_KEY"]!;
String your_db_pass = dotenv.env["YOUR_DB_PASS_KEY"]!;
