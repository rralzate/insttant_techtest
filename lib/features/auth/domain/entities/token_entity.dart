import 'package:equatable/equatable.dart';

import '../../../../core/entities/message.dart';
import '../../../../core/models/message.dart';
import '../../data/models/result_token_model.dart';
import 'result_token_entity.dart';

class TokenEntity extends Equatable {
  final bool success;
  final MessageResponseEntitie messageResponse;
  final ResultTokenEntity resultTokenEntity;

  const TokenEntity({
    required this.success,
    required this.messageResponse,
    required this.resultTokenEntity,
  });

  const TokenEntity.empty()
      : success = false,
        messageResponse = const MessageResponseEntitie.empty(),
        resultTokenEntity = const ResultTokenEntity.empty();

  @override
  List<Object?> get props => [
        success,
        messageResponse,
        resultTokenEntity,
      ];
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': (messageResponse as MessageResponseModel).toJson(),
      'result': (resultTokenEntity as ResultTokenModel).toJson(),
    };
  }

  @override
  String toString() {
    return ''' 
    ----- ----- ----- ----- ----- ----- ----- ----- -----
    Event Object
    ----- ----- ----- ----- ----- ----- ----- ----- -----
      Success: $success,
      Message: ${messageResponse.toString()},
      Result: ${resultTokenEntity.toString()},
    ''';
  }
}
