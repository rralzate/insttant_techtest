import '../../domain/entities/result_token_entity.dart';

class ResultTokenModel extends ResultTokenEntity {
  const ResultTokenModel({
    required super.password,
    required super.email,
  });

  //
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory ResultTokenModel.fromJson(Map<String, dynamic> json) {
    return ResultTokenModel(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }
}
