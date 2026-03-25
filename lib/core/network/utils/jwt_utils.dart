import 'dart:convert';

class JwtUtils {
  static bool isTokenExpired(
    String token, {
    Duration tolerance = const Duration(seconds: 30),
  }) {
    final expiry = _getExpiryEpoch(token);
    if (expiry == null) return true;
    final nowSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return expiry <= nowSeconds + tolerance.inSeconds;
  }

  static int? _getExpiryEpoch(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) return null;
      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final data = json.decode(payload);
      final exp = data['exp'];
      if (exp is int) return exp;
      if (exp is String) return int.tryParse(exp);
    } catch (_) {
      return null;
    }
    return null;
  }
}
