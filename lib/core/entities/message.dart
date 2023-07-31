import 'package:equatable/equatable.dart';

class MessageResponseEntitie extends Equatable {
  final String title;
  final String description;

  const MessageResponseEntitie({
    required this.title,
    required this.description,
  });

  const MessageResponseEntitie.empty()
      : title = '',
        description = '';

  @override
  List<Object?> get props => [
        title,
        description,
      ];

  @override
  String toString() {
    return ''' 
    ----- ----- ----- ----- ----- ----- ----- ----- -----
    Message Object
    ----- ----- ----- ----- ----- ----- ----- ----- -----
      Title: $title,
      Description: $description,
    ''';
  }
}
