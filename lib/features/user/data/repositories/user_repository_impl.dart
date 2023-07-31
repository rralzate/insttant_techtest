import 'package:dartz/dartz.dart';
import 'package:insttant_plus_mobile/core/network/failure.dart';
import 'package:insttant_plus_mobile/features/user/data/model/contact_model.dart';
import 'package:insttant_plus_mobile/features/user/domain/entities/contact_entity.dart';
import 'package:insttant_plus_mobile/features/user/domain/repositories/user_repository.dart';

import '../../../../core/network/exception.dart';
import '../datasources/user_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDatasource userDatasource;

  UserRepositoryImpl({
    required this.userDatasource,
  });

  @override
  Future<Either<Failure, bool>> saveImageProfile(
      {required String imagePath}) async {
    try {
      return Right(
          await userDatasource.setImageUserStorage(imagePath: imagePath));
    } on ServerException catch (e) {
      return Left(ErrorFailure(error: e.message));
    } on Object {
      return Left(ErrorFailure());
    }
  }

  @override
  Future<Either<Failure, String>> getImageProfile() async {
    try {
      return Right(await userDatasource.getImageUserStorage());
    } on ServerException catch (e) {
      return Left(ErrorFailure(error: e.message));
    } on Object {
      return Left(ErrorFailure());
    }
  }

  @override
  Future<Either<Failure, int>> deleteContact(
      {required ContactEntity contact}) async {
    try {
      ContactModel model = ContactModel(
          phone: contact.phone, name: contact.name, id: contact.id);
      return Right(await userDatasource.deleteContact(contact: model));
    } on ServerException catch (e) {
      return Left(ErrorFailure(error: e.message));
    } on Object {
      return Left(ErrorFailure());
    }
  }

  @override
  Future<Either<Failure, int>> insertUpdateContact(
      {required ContactEntity contact}) async {
    try {
      ContactModel model = ContactModel(
          phone: contact.phone, name: contact.name, id: contact.id);
      return Right(await userDatasource.insertUpdateContact(contact: model));
    } on ServerException catch (e) {
      return Left(ErrorFailure(error: e.message));
    } on Object {
      return Left(ErrorFailure());
    }
  }

  @override
  Future<Either<Failure, List<ContactEntity>>> getContacts() async {
    try {
      return Right((await userDatasource.getContacts()).cast<ContactEntity>());
    } on ServerException catch (e) {
      return Left(ErrorFailure(error: e.message));
    } on Object {
      return Left(ErrorFailure());
    }
  }
}
