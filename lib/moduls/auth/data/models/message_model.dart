import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({required super.message});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(message: (json['message'] ?? '').toString());
  }
}
