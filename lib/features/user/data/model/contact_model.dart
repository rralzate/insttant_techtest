import '../../domain/entities/contact_entity.dart';

class ContactModel extends ContactEntity {
  const ContactModel({
    required super.phone,
    required super.name,
    required super.id,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Phone': phone,
      'Name': name,
    };
  }

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['Id'] ?? '',
      phone: json['Phone'] ?? '',
      name: json['Name'] ?? '',
    );
  }
}
