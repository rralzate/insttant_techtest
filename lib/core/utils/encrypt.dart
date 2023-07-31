import 'package:encrypt/encrypt.dart';

// Método para encriptar un texto
String encryptText(String text) {
  final key = Key.fromUtf8('my32lengthsupersecretnooneknows1');
  final iv =
      IV.fromLength(16); // IV (Initialization Vector) de 16 bytes para AES
  final encrypter = Encrypter(AES(key));
  final encryptedText = encrypter.encrypt(text, iv: iv);

  return encryptedText.base64;
}

// Método para desencriptar un texto encriptado
String decryptText(String encryptedText) {
  final key = Key.fromUtf8('my32lengthsupersecretnooneknows1');
  final iv =
      IV.fromLength(16); // IV (Initialization Vector) de 16 bytes para AES
  final encrypter = Encrypter(AES(key));
  final encrypted = Encrypted.fromBase64(encryptedText);
  return encrypter.decrypt(encrypted, iv: iv);
}
