import 'package:equatable/equatable.dart';

class NewUserEntity extends Equatable {
  const NewUserEntity({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;

  final String email;
  final String password;

  @override
  List<Object?> get props => [
        name,
        email,
        password,
      ];

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
      };
}
