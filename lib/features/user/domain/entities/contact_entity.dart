import 'package:equatable/equatable.dart';

class ContactEntity extends Equatable {
  const ContactEntity({
    required this.name,
    required this.phone,
    required this.id,
  });

  final String name;

  final int phone;
  final int id;

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
      ];

  Map<String, dynamic> toJson() => {
        'Id': id,
        'Name': name,
        'Phone': phone,
      };
}
