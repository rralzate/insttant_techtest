part of 'user_bloc.dart';

class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

/// Class for get image user State /// -----------------------------------/// -----------------------------------/// -----------------------------------
class LoadingGetImageUserState extends UserState {
  @override
  List<Object?> get props => [];
}

class FailedGetImageUserState extends UserState {
  final String error;

  const FailedGetImageUserState({required this.error});
  @override
  List<Object?> get props => [error];
}

class GetImageUserState extends UserState {
  final String imagePath;

  const GetImageUserState({
    required this.imagePath,
  });

  @override
  List<Object?> get props => [imagePath];

  @override
  String toString() {
    return ''' 
      Get Image: 
        Path: ${imagePath.toString()}
    ''';
  }
}

class SuccessGetImageUserState extends UserState {
  final String imagePath;

  const SuccessGetImageUserState({
    required this.imagePath,
  });

  @override
  List<Object?> get props => [];
}

/// -----------------------------------/// -----------------------------------/// -----------------------------------/// -----------------------------------

/// Class for get user State /// -----------------------------------/// -----------------------------------/// -----------------------------------
class LoadingGetUserState extends UserState {
  @override
  List<Object?> get props => [];
}

class FailedGetUserState extends UserState {
  final String error;

  const FailedGetUserState({required this.error});
  @override
  List<Object?> get props => [error];
}

class GetUserState extends UserState {
  final NewUserEntity responseEntity;

  const GetUserState({
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

class SuccessGetUserState extends UserState {
  final NewUserEntity responseEntity;

  const SuccessGetUserState({
    required this.responseEntity,
  });

  @override
  List<Object?> get props => [];
}

/// -----------------------------------/// -----------------------------------/// -----------------------------------/// -----------------------------------

/// Class for insert contact user State /// -----------------------------------/// -----------------------------------/// -----------------------------------
class LoadingInsertUpdateContactState extends UserState {
  @override
  List<Object?> get props => [];
}

class FailedInsertUpdateContactState extends UserState {
  final String error;

  const FailedInsertUpdateContactState({required this.error});
  @override
  List<Object?> get props => [error];
}

class InsertUpdateContactState extends UserState {
  final int responseEntity;

  const InsertUpdateContactState({
    required this.responseEntity,
  });

  @override
  List<Object?> get props => [responseEntity];

  @override
  String toString() {
    return ''' 
      Insert contact: 
        Contact: ${responseEntity.toString()}
    ''';
  }
}

class SuccessInsertUpdateContactState extends UserState {
  final int responseEntity;

  const SuccessInsertUpdateContactState({
    required this.responseEntity,
  });

  @override
  List<Object?> get props => [];
}

/// -----------------------------------/// -----------------------------------/// -----------------------------------/// -----------------------------------

/// Class for get contacts State /// -----------------------------------/// -----------------------------------/// -----------------------------------
class LoadingGetContactsState extends UserState {
  @override
  List<Object?> get props => [];
}

class FailedGetContactsState extends UserState {
  final String error;

  const FailedGetContactsState({required this.error});
  @override
  List<Object?> get props => [error];
}

class GetContactsState extends UserState {
  final List<ContactEntity> responseEntity;

  const GetContactsState({
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

class SuccessGetContactsState extends UserState {
  final List<ContactEntity> responseEntity;

  const SuccessGetContactsState({
    required this.responseEntity,
  });

  @override
  List<Object?> get props => [];
}

/// -----------------------------------/// -----------------------------------/// -----------------------------------/// -----------------------------------

/// Class for delete contact State /// -----------------------------------/// -----------------------------------/// -----------------------------------
class LoadingDeleteContactState extends UserState {
  @override
  List<Object?> get props => [];
}

class FailedDeleteContactState extends UserState {
  final String error;

  const FailedDeleteContactState({required this.error});
  @override
  List<Object?> get props => [error];
}

class DeleteContactState extends UserState {
  final int result;

  const DeleteContactState({
    required this.result,
  });

  @override
  List<Object?> get props => [result];
}

class SuccessDeleteContactState extends UserState {
  final int result;

  const SuccessDeleteContactState({
    required this.result,
  });

  @override
  List<Object?> get props => [];
}

/// -----------------------------------/// -----------------------------------/// -----------------------------------/// -----------------------------------
