part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class ShowPasswordEvent extends AuthEvent {
  final bool showPassword;

  const ShowPasswordEvent(this.showPassword);
  @override
  List<Object?> get props => [];
}

class ShowPasswordConfirmEvent extends AuthEvent {
  final bool showPasswordConfirm;

  const ShowPasswordConfirmEvent(this.showPasswordConfirm);
  @override
  List<Object?> get props => [];
}

// Post information to register a new user/// -----------------------------------/// -----------------------------------/// -----------------------------------
class PostRegisterUserEvent extends AuthEvent {
  final NewUserEntity infoUserRegisterEntity;

  const PostRegisterUserEvent({
    required this.infoUserRegisterEntity,
  });

  @override
  List<Object> get props => [
        infoUserRegisterEntity,
      ];
}

class LogOutUserEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

// GET information to register a new user/// -----------------------------------/// -----------------------------------/// -----------------------------------
class GetRegisterUserEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class IsAuthenticatedEvent extends AuthEvent {
  final bool isAuthenticated;

  const IsAuthenticatedEvent(this.isAuthenticated);
  @override
  List<Object?> get props => [];
}

// Post login user/// -----------------------------------/// -----------------------------------/// -----------------------------------
class PostLoginUserEvent extends AuthEvent {
  final String userName;
  final String password;

  const PostLoginUserEvent({
    required this.password,
    required this.userName,
  });

  @override
  List<Object> get props => [
        password,
        userName,
      ];
}
