import 'package:insttant_plus_mobile/features/auth/data/models/result_token_model.dart';

import '../../../../core/models/message.dart';
import '../../domain/entities/result_token_entity.dart';

import '../../domain/entities/token_entity.dart';

class TokenModel extends TokenEntity {
  const TokenModel({
    required super.success,
    required super.messageResponse,
    required super.resultTokenEntity,
  });
  //

  @override
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': (messageResponse as MessageResponseModel).toJson(),
      'result': (resultTokenEntity as ResultTokenModel).toJson(),
    };
  }

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    MessageResponseModel messageResponseModel = const MessageResponseModel(
      title: '',
      description: '',
    );

    ResultTokenEntity resultTokenEntity = const ResultTokenEntity.empty();

    if (json.containsKey('message')) {
      messageResponseModel = MessageResponseModel.fromJson(json['message']);
    }

    if (json.containsKey('result')) {
      resultTokenEntity = ResultTokenModel.fromJson(json['result']);
    }

    return TokenModel(
      success: (json['success'] ?? false) as bool,
      messageResponse: messageResponseModel,
      resultTokenEntity: resultTokenEntity,
    );
  }
}
