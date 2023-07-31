import 'package:insttant_plus_mobile/features/user/domain/entities/contact_entity.dart';
import 'package:insttant_plus_mobile/features/user/presentation/bloc/user_bloc.dart';

class ParamsContactEditScreen {
  final UserBloc userBloc;
  final ContactEntity contactEntity;

  ParamsContactEditScreen({
    required this.userBloc,
    required this.contactEntity,
  });
}
