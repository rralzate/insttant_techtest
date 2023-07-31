import 'package:insttant_plus_mobile/features/auth/data/models/token_model.dart';
import 'package:insttant_plus_mobile/features/auth/domain/usescases/post_login.dart';
import 'package:insttant_plus_mobile/features/auth/domain/usescases/post_register_user.dart';

import 'package:insttant_plus_mobile/features/auth/domain/entities/new_user_entity.dart';

import 'package:insttant_plus_mobile/core/network/failure.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/models/message.dart';
import '../../../../core/network/exception.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/usescases/get_register_user.dart';
import '../datasources/auth_datasource.dart';
import '../models/new_user_model.dart';
import '../models/result_token_model.dart';

class AuthRepositoryImp implements AuthRepository {
  final AuthDatasource authDataSource;
  AuthRepositoryImp({
    required this.authDataSource,
  });

  @override
  Future<Either<Failure, UseCasePostRegisterUserResult>> postRegisterUser({
    required NewUserEntity userInfo,
  }) async {
    try {
      MessageResponseModel messageResponseModel = const MessageResponseModel(
        title: '',
        description: '',
      );

      ResultTokenModel resultTokenModel = ResultTokenModel(
        email: userInfo.email,
        password: userInfo.password,
      );

      TokenModel tokenModel = TokenModel(
        success: true,
        messageResponse: messageResponseModel,
        resultTokenEntity: resultTokenModel,
      );

      NewUserModel userModel = NewUserModel(
        password: userInfo.password,
        email: userInfo.email,
        name: userInfo.name,
      );

      await authDataSource.setRegisterUserStorage(entity: userModel);

      return Right(
        UseCasePostRegisterUserResult(result: tokenModel),
      );
    } on ServerException catch (e) {
      return Left(ErrorFailure(error: e.message));
    } on Object {
      return Left(ErrorFailure());
    }
  }

  @override
  Future<Either<Failure, UseCasePostLoginResult>> login(
      {required String email, required String password}) async {
    try {
      MessageResponseModel messageResponseModel = const MessageResponseModel(
        title: '',
        description: '',
      );

      ResultTokenModel resultTokenModel = ResultTokenModel(
        email: email,
        password: password,
      );

      TokenModel tokenModel = TokenModel(
        success: true,
        messageResponse: messageResponseModel,
        resultTokenEntity: resultTokenModel,
      );

      await authDataSource.setSecureStorage(model: tokenModel);

      return Right(
        UseCasePostLoginResult(result: tokenModel),
      );
    } on ServerException catch (e) {
      return Left(ErrorFailure(error: e.message));
    } on Object {
      return Left(ErrorFailure());
    }
  }

  @override
  Future<Either<Failure, UseCaseGetRegisterUserResult>>
      getRegisterUser() async {
    try {
      NewUserEntity newUserEntity =
          await authDataSource.getRegisterUserStorage();

      return Right(
        UseCaseGetRegisterUserResult(result: newUserEntity),
      );
    } on ServerException catch (e) {
      return Left(ErrorFailure(error: e.message));
    } on Object {
      return Left(ErrorFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> logoutApp() async {
    try {
      await authDataSource.deleteSecurityStorageUserInfo();

      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ErrorFailure(error: e.message));
    } on Object {
      return Left(ErrorFailure());
    }
  }
}
