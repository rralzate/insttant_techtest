import 'package:equatable/equatable.dart';

class ResultTokenEntity extends Equatable {
  final String password;
  final String email;

  const ResultTokenEntity({
    required this.email,
    e,
    required this.password,
  });

  const ResultTokenEntity.empty()
      : password = '',
        email = '';

  @override
  List<Object?> get props => [
        email,
        password,
      ];

  @override
  String toString() {
    return ''' 
    ----- ----- ----- ----- ----- ----- ----- ----- -----
    Result token Object
    ----- ----- ----- ----- ----- ----- ----- ----- -----
      
     
      Email: $email
      Password: $password,
      
    
    ''';
  }
}
