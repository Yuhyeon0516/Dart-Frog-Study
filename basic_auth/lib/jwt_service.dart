import 'package:basic_auth/typedefs.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

const secret = 'topsecret';

class JwtService {
  String sign(MapData payload) {
    final jwt = JWT(payload);

    return jwt.sign(
      SecretKey(secret),
      expiresIn: const Duration(days: 1),
    );
  }

  MapData? verify(String token) {
    try {
      final jwt = JWT.verify(token, SecretKey(secret));
      final payload = jwt.payload as MapData;

      return payload;
    } catch (e) {
      return null;
    }
  }
}
