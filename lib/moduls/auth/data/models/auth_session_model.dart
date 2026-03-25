import '../../domain/entities/auth_session_entity.dart';
import 'user_model.dart';

class AuthSessionModel extends AuthSessionEntity {
  const AuthSessionModel({
    required super.accessToken,
    required super.user,
    super.refreshToken,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      accessToken: (json['accessToken'] ?? '').toString(),
      refreshToken: json['refreshToken']?.toString(),
      user: UserModel.fromJson(
        (json['user'] as Map<String, dynamic>? ?? const {}),
      ),
    );
  }
}
