import 'package:equatable/equatable.dart';

class AccessTokenEntity extends Equatable {
  final String accessToken;

  const AccessTokenEntity({required this.accessToken});

  @override
  List<Object?> get props => [accessToken];
}
