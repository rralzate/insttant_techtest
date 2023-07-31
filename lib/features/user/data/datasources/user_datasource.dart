import '../model/contact_model.dart';

abstract class UserDatasource {
  Future<bool> setImageUserStorage({required String imagePath});

  Future<String> getImageUserStorage();

  Future<int> insertUpdateContact({required ContactModel contact});
  Future<ContactModel?> getContactById({required int id});

  Future<int> deleteContact({required ContactModel contact});

  Future<List<ContactModel?>> getContacts();
}
