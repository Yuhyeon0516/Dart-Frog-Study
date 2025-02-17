import 'dart:convert';

class Utils {
  static String createToken(String email, String password) {
    return base64.encode(utf8.encode('$email:$password'));
  }
}
