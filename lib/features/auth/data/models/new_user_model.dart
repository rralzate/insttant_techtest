import 'package:insttant_plus_mobile/features/auth/domain/entities/new_user_entity.dart';

class NewUserModel extends NewUserEntity {
  const NewUserModel({
    required super.password,
    required super.email,
    required super.name,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
    };
  }

  factory NewUserModel.fromJson(Map<String, dynamic> json) {
    return NewUserModel(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
