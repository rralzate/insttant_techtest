part of 'menu_bloc.dart';

class MenuState extends Equatable {
  final bool closeSession;
  final bool isShowingLogOutDialog;

  const MenuState({
    required this.closeSession,
    required this.isShowingLogOutDialog,
  });

  @override
  List<Object> get props => [
        closeSession,
        isShowingLogOutDialog,
      ];

  MenuState copyWith({
    bool? closeSession,
    bool? isShowingLogOutDialog,
  }) =>
      MenuState(
        closeSession: closeSession ?? this.closeSession,
        isShowingLogOutDialog:
            isShowingLogOutDialog ?? this.isShowingLogOutDialog,
      );
}
