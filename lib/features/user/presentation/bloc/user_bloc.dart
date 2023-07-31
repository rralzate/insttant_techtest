import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:insttant_plus_mobile/core/usescases/usecase.dart';
import 'package:insttant_plus_mobile/features/user/domain/entities/contact_entity.dart';
import 'package:rxdart/rxdart.dart';

import '../../../auth/domain/entities/new_user_entity.dart';
import '../../../auth/domain/usescases/get_register_user.dart';
import '../../domain/usescases/delete_contact.dart';
import '../../domain/usescases/get_contacts.dart';
import '../../domain/usescases/get_image_profile.dart';
import '../../domain/usescases/insert_update_contact.dart';
import '../../domain/usescases/save_image_profile.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  SaveImageProfile saveImageProfile;
  GetImageProfile getImageProfile;
  GetRegisterUserUseCase getRegisterUserUseCase;
  InsertUpdateContact insertUpdateContact;
  GetContacts getContacts;
  DeleteContact deleteContact;

  final nameFieldController = BehaviorSubject<String>();
  final phoneFieldController = BehaviorSubject<String>();

  Stream<String> get nameStream => nameFieldController.stream;
  Stream<String> get phoneStream => phoneFieldController.stream;

  UserBloc({
    required this.saveImageProfile,
    required this.getImageProfile,
    required this.getRegisterUserUseCase,
    required this.insertUpdateContact,
    required this.getContacts,
    required this.deleteContact,
  }) : super(const UserState()) {
    on<GetUserEvent>(
      (event, emit) async {
        emit(await _getRegisterUser(event: event, emit: emit));
      },
    );
    on<SaveImageUserEvent>((event, emit) async {
      await _saveImageUser(event: event, emit: emit);
    });

    on<GetImageUserEvent>((event, emit) async {
      emit(await _getImageUser(event: event, emit: emit));
    });

    on<InsertContactUserEvent>(
      (event, emit) async {
        emit(await _insertUpdateContactUser(event: event, emit: emit));
      },
    );

    on<GetContactsEvent>(
      (event, emit) async {
        emit(await _getContacts(event: event, emit: emit));
      },
    );
    on<DeleteContactUserEvent>(
      (event, emit) async {
        emit(await _deleteContact(event: event, emit: emit));
      },
    );
  }

  Future<UserState> _deleteContact({
    required DeleteContactUserEvent event,
    required Emitter<UserState> emit,
  }) async {
    emit(LoadingDeleteContactState());
    final user = await deleteContact(event.entity);

    return user.fold((failure) {
      emit(
        FailedDeleteContactState(
          error: failure.props.isNotEmpty ? failure.props.first.toString() : '',
        ),
      );

      // ignore: prefer_const_constructors
      return DeleteContactState(result: 0);
    }, (response) {
      emit(SuccessDeleteContactState(result: response));

      return DeleteContactState(result: response);
    });
  }

  Future<void> _saveImageUser({
    required SaveImageUserEvent event,
    required Emitter<UserState> emit,
  }) async {
    await saveImageProfile(event.imagePath);
  }

  Future<UserState> _getImageUser({
    required GetImageUserEvent event,
    required Emitter<UserState> emit,
  }) async {
    emit(LoadingGetImageUserState());
    final user = await getImageProfile(
      NoParams(),
    );

    return user.fold((failure) {
      emit(
        FailedGetImageUserState(
          error: failure.props.isNotEmpty ? failure.props.first.toString() : '',
        ),
      );

      // ignore: prefer_const_constructors
      return GetImageUserState(imagePath: '');
    }, (response) {
      emit(SuccessGetImageUserState(imagePath: response));

      return GetImageUserState(imagePath: response);
    });
  }

  Future<UserState> _getRegisterUser({
    required GetUserEvent event,
    required Emitter<UserState> emit,
  }) async {
    emit(LoadingGetUserState());
    final user = await getRegisterUserUseCase(NoParams());

    return user.fold((failure) {
      emit(
        FailedGetUserState(
          error: failure.props.isNotEmpty ? failure.props.first.toString() : '',
        ),
      );

      return const GetUserState(
        responseEntity: NewUserEntity(name: '', email: '', password: ''),
      );
    }, (response) {
      emit(SuccessGetUserState(responseEntity: response.result));

      return GetUserState(responseEntity: response.result);
    });
  }

  void updateName(String field) async {
    if (field.isEmpty) {
      nameFieldController.sink.addError('Este campo es requerido');
    } else if (field.length > 50) {
      nameFieldController.sink.addError('El máximo de caracteres es 50');
    } else if (field.length < 2) {
      nameFieldController.sink.addError('El mínimo de caracteres es 2');
    } else {
      nameFieldController.sink.add(field);
    }
  }

  void updatePhone(String phoneStream) async {
    if (phoneStream.isEmpty) {
      phoneFieldController.sink.addError('Este campo es requerido');
    } else if (phoneStream.length < 6) {
      phoneFieldController.sink.addError('El mínimo de caracteres es 6');
    } else {
      phoneFieldController.sink.add(phoneStream);
    }
  }

  Stream<bool> get validateUserDataModalUpdate => Rx.combineLatest2(
        phoneFieldController.stream,
        nameFieldController.stream,
        (a, b) => true,
      );

  Future<UserState> _insertUpdateContactUser({
    required InsertContactUserEvent event,
    required Emitter<UserState> emit,
  }) async {
    emit(LoadingInsertUpdateContactState());
    final user = await insertUpdateContact(event.entity);

    return user.fold((failure) {
      emit(
        FailedInsertUpdateContactState(
          error: failure.props.isNotEmpty ? failure.props.first.toString() : '',
        ),
      );

      return const InsertUpdateContactState(
        responseEntity: 0,
      );
    }, (response) {
      emit(SuccessInsertUpdateContactState(responseEntity: response));

      return InsertUpdateContactState(responseEntity: response);
    });
  }

  Future<UserState> _getContacts({
    required GetContactsEvent event,
    required Emitter<UserState> emit,
  }) async {
    emit(LoadingGetContactsState());
    final user = await getContacts(NoParams());

    return user.fold((failure) {
      emit(
        FailedGetContactsState(
          error: failure.props.isNotEmpty ? failure.props.first.toString() : '',
        ),
      );

      return const GetContactsState(
        responseEntity: [],
      );
    }, (response) {
      emit(SuccessGetContactsState(responseEntity: response));

      return GetContactsState(responseEntity: response);
    });
  }
}
