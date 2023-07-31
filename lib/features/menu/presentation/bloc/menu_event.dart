part of 'menu_bloc.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object?> get props => [];
}

class CloseSessionEvent extends MenuEvent {
  @override
  List<Object?> get props => [];
}

class OpenShowLogOutDialogEvent extends MenuEvent {
  @override
  List<Object?> get props => [];
}

class CloseShowLogOutDialogEvent extends MenuEvent {
  @override
  List<Object?> get props => [];
}
