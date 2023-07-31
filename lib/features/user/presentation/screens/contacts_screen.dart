import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insttant_plus_mobile/core/components/custom_input.dart';
import 'package:insttant_plus_mobile/core/components/custom_loading.dart';
import 'package:insttant_plus_mobile/core/routes/resource_icons.dart';
import 'package:insttant_plus_mobile/features/user/domain/entities/contact_entity.dart';
import 'package:insttant_plus_mobile/features/user/domain/entities/params_contact_edit.dart';
import 'package:insttant_plus_mobile/features/user/presentation/screens/new_contact_screen.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/components/custom_confirm_dialog_box.dart';
import '../../../../core/injection/injection_container.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/fonts.dart';
import '../../../../core/widgets/header.dart';

import '../bloc/user_bloc.dart';
import '../widgets/contact_detail_screen.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});
  static const String routeName = '/';

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final UserBloc userBloc = getIt<UserBloc>();
  final FocusNode _nodeTextField1 = FocusNode();
  List<Contact> _contacts = [];
  List<ContactEntity> _contactsApplication = [];
  bool permissionDenied = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    userBloc.add(GetContactsEvent());
    _fetchContacts();
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts();
      setState(() => _contacts = contacts);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      body: SafeArea(
        child: BlocProvider.value(
          value: userBloc,
          child: BlocConsumer<UserBloc, UserState>(
            listener: (context, state) {
              // ------// ------// ------// ------// ------// ------// ------
              if (state is LoadingGetContactsState) {
                setState(() {
                  _isLoading = true;
                });
              }
              if (state is FailedGetContactsState) {
                setState(() {
                  _isLoading = false;
                });
              }
              if (state is SuccessGetContactsState) {
                setState(() {
                  _contactsApplication = state.responseEntity;
                  _isLoading = false;
                });
              }
            },
            builder: (context, state) {
              return Stack(children: [
                _principalBody(),
                Visibility(
                  visible: (_contacts.isEmpty) || _isLoading,
                  child: const CustomLoadingScreen(),
                )
              ]);
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        backgroundColor: mainGrey,
        onPressed: () async {
          ContactEntity contactEntity =
              const ContactEntity(name: '', phone: 0, id: 0);
          ParamsContactEditScreen paramsContactEditScreen =
              ParamsContactEditScreen(
            userBloc: userBloc,
            contactEntity: contactEntity,
          );
          Navigator.pushNamed(context, NewContactScreen.routeName,
              arguments: paramsContactEditScreen);
        },
        child: const Icon(
          Icons.add_rounded,
          color: highlightRed,
        ),
      ),
    );
  }

  Widget _principalBody() {
    return Container(
      padding: EdgeInsets.all(5.w),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderBaseScreen(
            title: 'Contactos',
            //back: () => Navigator.pop(context),
          ),
          _searchInput(),
          Text(
            'Contactos Aplicación',
            style: textBlackStyleSubTitle,
          ),
          _listContactsApplication(),
          SizedBox(
            height: 2.h,
          ),
          Text(
            'Contactos Celular',
            style: textBlackStyleSubTitle,
          ),
          _listContacts(),
          SizedBox(
            height: 1.h,
          ),
        ],
      ),
    );
  }

  Widget _listContacts() {
    return Expanded(
      child: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, i) => ListTile(
          title: Text(_contacts[i].displayName),
          onTap: () async {
            final fullContact =
                await FlutterContacts.getContact(_contacts[i].id);
            // ignore: use_build_context_synchronously
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ConctactDetailScreen(
                      contact: fullContact!,
                    )));
          },
        ),
      ),
    );
  }

  Widget _listContactsApplication() {
    return Expanded(
      child: ListView.builder(
        itemCount: _contactsApplication.length,
        itemBuilder: (context, i) => Card(
          elevation: 6,
          margin: const EdgeInsets.all(5),
          child: popupOptions(context, i),
        ),
      ),
    );
  }

  PopupMenuButton<dynamic> popupOptions(BuildContext context, int i) {
    return PopupMenuButton(
      onSelected: (value) async {
        switch (value) {
          case '/eliminate':
            await _showDialogForDeleteAccount(
              onAccept: () {
                _deleteContact(i);
              },
            );

            break;

          case '/edit':
            ContactEntity contactEntity = ContactEntity(
                name: _contactsApplication[i].name,
                phone: _contactsApplication[i].phone,
                id: _contactsApplication[i].id);
            ParamsContactEditScreen paramsContactEditScreen =
                ParamsContactEditScreen(
              userBloc: userBloc,
              contactEntity: contactEntity,
            );
            Navigator.pushNamed(context, NewContactScreen.routeName,
                arguments: paramsContactEditScreen);

            break;
          default:
        }
      },
      child: _optionTile(i),
      itemBuilder: (context) => <PopupMenuEntry>[
        PopupMenuItem(
          value: '/eliminate',
          child: Text(
            'Eliminar',
            style: textBlackStyle,
          ),
        ),
        PopupMenuItem(
          value: '/edit',
          child: Text(
            'Editar',
            style: textBlackStyle,
          ),
        ),
      ],
    );
  }

  void _deleteContact(int i) {
    ContactEntity contactEntity = ContactEntity(
      name: _contactsApplication[i].name,
      phone: _contactsApplication[i].phone,
      id: _contactsApplication[i].id,
    );
    userBloc.add(DeleteContactUserEvent(
      entity: contactEntity,
    ));
    _success();
  }

  ListTile _optionTile(int i) {
    return ListTile(
      title: Text(
        _contactsApplication[i].name,
        style: textBlackStyleSubTitle,
      ),
      subtitle: Text(
        _contactsApplication[i].phone.toString(),
      ),
      trailing: const Icon(Icons.menu),
    );
  }

  Widget _searchInput() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: CustomInput(
          placeholder: 'Buscar',
          focusNode: _nodeTextField1,
          prefixIcon: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: SvgPicture.asset(
              searchSVG,
              width: 6.w,
              color: mainGrey,
            ),
          ),
          onChanged: (value) async {
            if (value.isNotEmpty && value.length > 3) {
              setState(() {
                _contactsApplication = filterContacts(value);
              });
            } else {
              userBloc.add(GetContactsEvent());
            }
          },
        ),
      ),
    );
  }

  List<ContactEntity> filterContacts(String value) {
    final contactsApp =
        _contactsApplication.where((element) => element.name.contains(
              value,
            ));
    return contactsApp.toList();
  }

  void _success() {
    Navigator.pushNamed(
      context,
      ContactsScreen.routeName,
    );
  }

  Future<void> _showDialogForDeleteAccount({
    required VoidCallback onAccept,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext ctex) {
        return CustomConfirmDialogBox(
          icon: SvgPicture.asset(warningModalSVG),
          title: '¿Estás seguro que deseas eliminar el contacto?',
          confirmText: 'Aceptar',
          cancelText: 'Cancelar',
          descriptions:
              'Si eliminas el contacto, toda la información se eliminará por completo.',
          onAccept: () async {
            Navigator.pop(ctex, false);
            onAccept();
          },
          onCancel: () async {
            Navigator.pop(ctex, false);
          },
        );
      },
    );
  }
}
