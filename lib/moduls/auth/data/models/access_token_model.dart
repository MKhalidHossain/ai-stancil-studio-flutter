import '../../domain/entities/access_token_entity.dart';

class AccessTokenModel extends AccessTokenEntity {
  const AccessTokenModel({required super.accessToken});

  factory AccessTokenModel.fromJson(Map<String, dynamic> json) {
    return AccessTokenModel(
      accessToken: (json['accessToken'] ?? '').toString(),
    );
  }
}
