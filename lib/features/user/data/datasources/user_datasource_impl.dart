import 'package:insttant_plus_mobile/features/user/data/datasources/user_datasource.dart';
import 'package:insttant_plus_mobile/features/user/data/model/contact_model.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/data/database_service.dart';
import '../../../../core/utils/share_preferences_actions.dart';

const _userImagePathStorageKey = 'user_imagepath';

class UserDatasourceImpl implements UserDatasource {
  static final Future<Database> _database = DataBaseService.db.database;

  @override
  Future<bool> setImageUserStorage({required String imagePath}) async {
    await Future.delayed(const Duration(seconds: 2));
    await SharePreferencesAction.setActionFromSecureStorage(
      key: _userImagePathStorageKey,
      value: imagePath,
    );
    return true;
  }

  @override
  Future<String> getImageUserStorage() async {
    String storage = await SharePreferencesAction.getActionFromSecureStorage(
      key: _userImagePathStorageKey,
    );
    return storage;
  }

  @override
  Future<int> insertUpdateContact({required ContactModel contact}) async {
    final db = await _database;
    Batch batch = db.batch();

    if (contact.id == 0) {
      batch.rawInsert(
          '''INSERT INTO Contacts (Name, Phone) VALUES ('${contact.name}', ${contact.phone})''');
    } else {
      batch.update('Contacts', contact.toJson(),
          where: 'Id = ?', whereArgs: [contact.id]);
    }

    batch.commit();
    return batch.length;
  }

  @override
  Future<ContactModel?> getContactById({required int id}) async {
    final db = await _database;

    final res = await db.query('Contacts', where: 'Id = ?', whereArgs: [id]);

    return res.isNotEmpty ? ContactModel.fromJson(res.first) : null;
  }

  @override
  Future<int> deleteContact({required ContactModel contact}) async {
    final db = await _database;

    int res =
        await db.delete('Contacts', where: 'Id = ?', whereArgs: [contact.id]);

    return res;
  }

  @override
  Future<List<ContactModel?>> getContacts() async {
    final db = await _database;

    final res = await db.query('Contacts');

    return res.isNotEmpty
        ? res
            .map(
              (contacts) => ContactModel.fromJson(contacts),
            )
            .toList()
        : [];
  }
}
