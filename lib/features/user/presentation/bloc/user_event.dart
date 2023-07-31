part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

// Post information image a new user/// -----------------------------------/// -----------------------------------/// -----------------------------------
class SaveImageUserEvent extends UserEvent {
  final String imagePath;

  const SaveImageUserEvent({
    required this.imagePath,
  });

  @override
  List<Object> get props => [
        imagePath,
      ];
}

class GetImageUserEvent extends UserEvent {
  @override
  List<Object> get props => [];
}

// GET information to register a new user/// -----------------------------------/// -----------------------------------/// -----------------------------------
class GetUserEvent extends UserEvent {
  @override
  List<Object> get props => [];
}

class InsertContactUserEvent extends UserEvent {
  final ContactEntity entity;

  const InsertContactUserEvent({required this.entity});

  @override
  List<Object> get props => [entity];
}

// GET information to contacts/// -----------------------------------/// -----------------------------------/// -----------------------------------
class GetContactsEvent extends UserEvent {
  @override
  List<Object> get props => [];
}

// Delete Contact/// -----------------------------------/// -----------------------------------/// -----------------------------------
class DeleteContactUserEvent extends UserEvent {
  final ContactEntity entity;

  const DeleteContactUserEvent({
    required this.entity,
  });

  @override
  List<Object> get props => [
        entity,
      ];
}
