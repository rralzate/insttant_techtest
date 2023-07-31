import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/header_contacts.dart';
import '../screens/contacts_screen.dart';

class ConctactDetailScreen extends StatelessWidget {
  const ConctactDetailScreen({super.key, required this.contact});

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(5.w),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            HeaderContactScreen(
              back: () => Navigator.pushReplacementNamed(
                context,
                ContactsScreen.routeName,
              ),
              title: contact.displayName,
              backEdit: () async {
                await FlutterContacts.openExternalEdit(contact.id);
              },
            ),
            Text('First name: ${contact.name.first}'),
            Text('Last name: ${contact.name.last}'),
            Text(
                'Phone number: ${contact.phones.isNotEmpty ? contact.phones.first.number : '(none)'}'),
            Text(
                'Email address: ${contact.emails.isNotEmpty ? contact.emails.first.address : '(none)'}'),
          ]),
        ),
      ),
    );
  }
}
