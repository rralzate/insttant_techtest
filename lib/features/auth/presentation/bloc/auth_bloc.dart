import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:insttant_plus_mobile/core/entities/message.dart';
import 'package:insttant_plus_mobile/core/extensions/string_extension.dart';
import 'package:insttant_plus_mobile/core/usescases/usecase.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/datasources/auth_datasource.dart';
import '../../domain/entities/new_user_entity.dart';
import '../../domain/entities/result_token_entity.dart';
import '../../domain/entities/token_entity.dart';
import '../../domain/usescases/get_register_user.dart';
import '../../domain/usescases/logout_app_auth_usecase.dart';
import '../../domain/usescases/post_login.dart';
import '../../domain/usescases/post_register_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  PostRegisterUserUseCase postRegisterUserUseCase;
  GetRegisterUserUseCase getRegisterUserUseCase;
  LogoutAppUseCase logoutAppUseCase;
  PostLoginUseCase postLoginUseCase;

  final AuthDatasource authDataSource;
  //define controllers login
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _passwordConfirmController = BehaviorSubject<String>();

  //define controllers register form
  final _nameController = BehaviorSubject<String>();

  //get data
  Stream<String> get emailStream => _emailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;

  Stream<String> get passwordConfirmtream => _passwordConfirmController.stream;
  //get data register form
  Stream<String> get nameStream => _nameController.stream;

  AuthBloc({
    required this.postRegisterUserUseCase,
    required this.getRegisterUserUseCase,
    required this.logoutAppUseCase,
    required this.postLoginUseCase,
    required this.authDataSource,
  }) : super(const AuthState()) {
    on<ShowPasswordEvent>(
      (event, emit) => emit(state.copyWith(showPassword: event.showPassword)),
    );
    on<ShowPasswordConfirmEvent>(
      (event, emit) =>
          emit(state.copyWith(showPasswordConfirm: event.showPasswordConfirm)),
    );

    on<PostRegisterUserEvent>(
      (event, emit) async {
        emit(await _postRegisterUser(event: event, emit: emit));
      },
    );
    on<PostLoginUserEvent>(
      (event, emit) async {
        emit(await _postLoginUser(event: event, emit: emit));
      },
    );

    on<GetRegisterUserEvent>(
      (event, emit) async {
        emit(await _getRegisterUser(event: event, emit: emit));
      },
    );

    on<LogOutUserEvent>((event, emit) async {
      emit(await _logOutApp());
    });
  }

  //validation of logion Email
  void updateEmail(String userEmail) async {
    if (userEmail.isEmpty) {
      _emailController.sink.addError('Este campo es requerido');
    } else if (!userEmail.validateEmail) {
      _emailController.sink.addError('Escribe un correo válido');
    } else if (userEmail.length < 6) {
      _nameController.sink.addError('El mínimo de caracteres es 6');
    } else {
      _emailController.sink.add(userEmail);
    }
  }

  //validation of Password form
  void updatePassword(String password) {
    if (password.isEmpty) {
      _passwordController.sink.addError('Este campo es requerido');
    } else {
      if (!password.validatePassword) {
        _passwordController.sink.addError(
            'Mínimo 10 caracteres con una letra mayúscula y un símbolo Ej: &%\$#!');
      } else {
        _passwordController.sink.add(password);
      }
    }
  }

  //validation of Password form
  void updatePasswordConfirm(String password) {
    if (password.isEmpty) {
      _passwordConfirmController.sink.addError('Este campo es requerido');
    } else {
      if (!password.validatePassword) {
        _passwordConfirmController.sink.addError(
            'Mínimo 10 caracteres con una letra mayúscula y un símbolo Ej: &%\$#!');
      }
      if (_passwordController.value != password) {
        _passwordConfirmController.sink
            .addError('Las contraseñas no coinciden');
      } else {
        _passwordConfirmController.sink.add(password);
      }
    }
  }

  void updateName(String field) async {
    if (field.isEmpty) {
      _nameController.sink.addError('Este campo es requerido');
    } else if (field.length > 50) {
      _nameController.sink.addError('El máximo de caracteres es 50');
    } else if (field.length < 4) {
      _nameController.sink.addError('El mínimo de caracteres es 4');
    } else {
      _nameController.sink.add(field);
    }
  }

  Future<AuthState> _postRegisterUser({
    required PostRegisterUserEvent event,
    required Emitter<AuthState> emit,
  }) async {
    emit(LoadingPostRegisterUserState());
    final user = await postRegisterUserUseCase(
      ParamsUseCaseRegisterUser(
        infoUserRegisterEntity: event.infoUserRegisterEntity,
      ),
    );

    return user.fold((failure) {
      emit(
        FailedPostRegisterUserState(
          error: failure.props.isNotEmpty ? failure.props.first.toString() : '',
        ),
      );
      emit(InitPostRegisterUserState());
      // ignore: prefer_const_constructors
      return PostRegisterUserState(
        responseEntity: TokenEntity(
          messageResponse: MessageResponseEntitie(
            title: '',
            description:
                failure.props.isNotEmpty ? failure.props.first.toString() : '',
          ),
          resultTokenEntity: const ResultTokenEntity.empty(),
          success: false,
        ),
      );
    }, (response) {
      emit(SuccessPostRegisterUserState(responseEntity: response.result));

      return PostRegisterUserState(responseEntity: response.result);
    });
  }

  Future<AuthState> _postLoginUser({
    required PostLoginUserEvent event,
    required Emitter<AuthState> emit,
  }) async {
    emit(LoadingPostLoginEmailState());
    final user = await postLoginUseCase(
      ParamsUseCaseParamsPostLogin(
        password: event.password,
        userName: event.userName,
      ),
    );

    return user.fold((failure) {
      emit(
        FailedPostLoginEmailState(
          error: failure.props.isNotEmpty ? failure.props.first.toString() : '',
        ),
      );
      emit(InitPostLoginEmailState());
      // ignore: prefer_const_constructors
      return PostLoginEmailState(
        tokenEntity: TokenEntity(
          messageResponse: MessageResponseEntitie(
            title: '',
            description:
                failure.props.isNotEmpty ? failure.props.first.toString() : '',
          ),
          resultTokenEntity: const ResultTokenEntity.empty(),
          success: false,
        ),
      );
    }, (response) {
      emit(SuccessPostLoginEmailState(tokenEntity: response.result));
      authDataSource.setSecureStorage(model: response.result);
      return PostLoginEmailState(tokenEntity: response.result);
    });
  }

  Future<bool> isUserLogin() async {
    bool response = false;

    TokenEntity userEntity = const TokenEntity.empty();

    try {
      userEntity = await authDataSource.getSecureStorage();
    } catch (_) {}

    if (userEntity.resultTokenEntity.email.isNotEmpty &&
        userEntity.resultTokenEntity.password.isNotEmpty) {
      response = true;
    }
    return response;
  }

  Future<AuthState> _getRegisterUser({
    required GetRegisterUserEvent event,
    required Emitter<AuthState> emit,
  }) async {
    emit(LoadingGetRegisterUserState());
    final user = await getRegisterUserUseCase(NoParams());

    return user.fold((failure) {
      emit(
        FailedGetRegisterUserState(
          error: failure.props.isNotEmpty ? failure.props.first.toString() : '',
        ),
      );

      return const GetRegisterUserState(
        responseEntity: NewUserEntity(name: '', email: '', password: ''),
      );
    }, (response) {
      emit(SuccessGetRegisterUserState(responseEntity: response.result));

      return GetRegisterUserState(responseEntity: response.result);
    });
  }

  //check login validation form
  Stream<bool> get validateLoginForm => Rx.combineLatest2(
        emailStream,
        passwordStream,
        (a, b) => true,
      );

  //check Register validation form
  Stream<bool> get validateRegisterForm => Rx.combineLatest3(
        nameStream,
        emailStream,
        passwordStream,
        (
          a,
          b,
          c,
        ) =>
            true,
      );

  void dispose() {
    _emailController.close();
    _passwordController.close();
  }

  Future<AuthState> _logOutApp() async {
    bool response = false;

    final result = await logoutAppUseCase(NoParams());

    result.fold((failure) {
      response = false;
    }, (success) {});

    return LogOutUserState(result: response);
  }
}
