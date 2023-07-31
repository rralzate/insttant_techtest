import 'dart:convert';

import 'package:insttant_plus_mobile/features/auth/domain/entities/new_user_entity.dart';
import 'package:insttant_plus_mobile/features/auth/domain/entities/token_entity.dart';

import 'package:insttant_plus_mobile/features/auth/data/models/token_model.dart';

import '../../../../core/utils/share_preferences_actions.dart';
import '../models/new_user_model.dart';
import 'auth_datasource.dart';

const _userCredentialsStorageKey = 'user_credentials';
const _userRegisterStorageKey = 'user_register';

class AuthDatasourceImpl implements AuthDatasource {
  @override
  Future<TokenEntity> getSecureStorage() async {
    String storage = await SharePreferencesAction.getActionFromSecureStorage(
      key: _userCredentialsStorageKey,
    );
    return TokenModel.fromJson(jsonDecode(storage));
  }

  @override
  Future<TokenEntity> setSecureStorage({required TokenEntity model}) async {
    await Future.delayed(const Duration(seconds: 2));
    await SharePreferencesAction.setActionFromSecureStorage(
      key: _userCredentialsStorageKey,
      value: jsonEncode(model.toJson()),
    );
    return model;
  }

  @override
  Future<NewUserEntity> setRegisterUserStorage(
      {required NewUserModel entity}) async {
    await Future.delayed(const Duration(seconds: 2));
    await SharePreferencesAction.setActionFromSecureStorage(
      key: _userRegisterStorageKey,
      value: jsonEncode(entity.toJson()),
    );
    return entity;
  }

  @override
  Future<NewUserEntity> getRegisterUserStorage() async {
    String storage = await SharePreferencesAction.getActionFromSecureStorage(
      key: _userRegisterStorageKey,
    );
    return NewUserModel.fromJson(jsonDecode(storage));
  }

  @override
  Future<bool> deleteSecurityStorageUserInfo() async {
    bool response = false;

    await SharePreferencesAction.deleteActionFromSecureStorage(
      key: _userCredentialsStorageKey,
    );
    response = true;
    return response;
  }
}
