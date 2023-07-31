part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final bool showPassword;
  final bool showPasswordConfirm;

  const AuthState({
    this.showPassword = false,
    this.showPasswordConfirm = false,
  });
  AuthState copyWith({
    bool? showPassword,
    bool? showPasswordConfirm,
  }) =>
      AuthState(
        showPassword: showPassword ?? this.showPassword,
        showPasswordConfirm: showPasswordConfirm ?? this.showPasswordConfirm,
      );
  @override
  List<Object?> get props => [
        showPassword,
        showPasswordConfirm,
      ];
}

// Class for login State /// -----------------------------------/// -----------------------------------/// -----------------------------------

class LoadingPostLoginEmailState extends AuthState {
  @override
  List<Object?> get props => [];
}

class FailedPostLoginEmailState extends AuthState {
  final String error;

  const FailedPostLoginEmailState({required this.error});
  @override
  List<Object?> get props => [error];
}

class InitPostLoginEmailState extends AuthState {
  @override
  List<Object?> get props => [];
}

class PostLoginEmailState extends AuthState {
  final TokenEntity tokenEntity;

  const PostLoginEmailState({
    required this.tokenEntity,
  });

  @override
  List<Object?> get props => [tokenEntity];

  @override
  String toString() {
    return ''' 
      Get Token: 
        Tolken: ${tokenEntity.toString()}
    ''';
  }
}

class SuccessPostLoginEmailState extends AuthState {
  final TokenEntity tokenEntity;

  const SuccessPostLoginEmailState({
    required this.tokenEntity,
  });

  @override
  List<Object?> get props => [];
}

/// -----------------------------------/// -----------------------------------/// -----------------------------------/// -----------------------------------

/// Class for register user State /// -----------------------------------/// -----------------------------------/// -----------------------------------
class LoadingPostRegisterUserState extends AuthState {
  @override
  List<Object?> get props => [];
}

class FailedPostRegisterUserState extends AuthState {
  final String error;

  const FailedPostRegisterUserState({required this.error});
  @override
  List<Object?> get props => [error];
}

class InitPostRegisterUserState extends AuthState {
  @override
  List<Object?> get props => [];
}

class PostRegisterUserState extends AuthState {
  final TokenEntity responseEntity;

  const PostRegisterUserState({
    required this.responseEntity,
  });

  @override
  List<Object?> get props => [responseEntity];

  @override
  String toString() {
    return ''' 
      Get Token: 
        Tolken: ${responseEntity.toString()}
    ''';
  }
}

class SuccessPostRegisterUserState extends AuthState {
  final TokenEntity responseEntity;

  const SuccessPostRegisterUserState({
    required this.responseEntity,
  });

  @override
  List<Object?> get props => [];
}

/// -----------------------------------/// -----------------------------------/// -----------------------------------/// -----------------------------------

/// Class for get user State /// -----------------------------------/// -----------------------------------/// -----------------------------------
class LoadingGetRegisterUserState extends AuthState {
  @override
  List<Object?> get props => [];
}

class FailedGetRegisterUserState extends AuthState {
  final String error;

  const FailedGetRegisterUserState({required this.error});
  @override
  List<Object?> get props => [error];
}

class GetRegisterUserState extends AuthState {
  final NewUserEntity responseEntity;

  const GetRegisterUserState({
    required this.responseEntity,
  });

  @override
  List<Object?> get props => [responseEntity];

  @override
  String toString() {
    return ''' 
      Get User: 
        User: ${responseEntity.toString()}
    ''';
  }
}

class SuccessGetRegisterUserState extends AuthState {
  final NewUserEntity responseEntity;

  const SuccessGetRegisterUserState({
    required this.responseEntity,
  });

  @override
  List<Object?> get props => [];
}

/// -----------------------------------/// -----------------------------------/// -----------------------------------/// -----------------------------------
class LogOutUserState extends AuthState {
  final bool result;

  const LogOutUserState({
    required this.result,
  });

  @override
  List<Object?> get props => [result];
}
