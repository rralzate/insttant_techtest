import '../../domain/entities/new_user_entity.dart';
import '../../domain/entities/token_entity.dart';
import '../models/new_user_model.dart';

abstract class AuthDatasource {
  Future<TokenEntity> getSecureStorage();
  Future<TokenEntity> setSecureStorage({required TokenEntity model});
  Future<NewUserEntity> setRegisterUserStorage({required NewUserModel entity});
  Future<NewUserEntity> getRegisterUserStorage();

  Future<bool> deleteSecurityStorageUserInfo();
}
