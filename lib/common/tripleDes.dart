import 'package:tripledes/tripledes.dart';

class TripleDesUtil {
  /// md5 加密
  static String generateDes(String password) {
    var key = 'xglAJa0P1QAQi1Z9aAqnL8l4';
    var blockCipher = new BlockCipher(new TripleDESEngine(), key);
    var ciphertext = blockCipher.encodeB64(password);
    return ciphertext;
  }
}