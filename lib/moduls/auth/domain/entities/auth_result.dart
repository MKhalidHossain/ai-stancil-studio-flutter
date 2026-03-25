import 'package:equatable/equatable.dart';

class AuthResult<T> extends Equatable {
  final T data;
  final String message;

  const AuthResult({
    required this.data,
    required this.message,
  });

  @override
  List<Object?> get props => [data, message];
}
