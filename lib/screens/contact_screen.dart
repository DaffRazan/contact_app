import 'package:contact_app/cubits/contact/contact_cubit.dart';
import 'package:contact_app/models/contact.dart';
import 'package:contact_app/screens/update_contact_screen.dart';
import 'package:contact_app/utils/color.dart';
import 'package:contact_app/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactScreen extends StatefulWidget {
  final ContactCubit contactCubit;

  const ContactScreen({super.key, required this.contactCubit});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  String loggedInName = '';
  String loggedInId = '';

  @override
  void initState() {
    super.initState();

    getUsername();
    getLoggedInId();

    widget.contactCubit.getAndSortContactsAlphabetically();
  }

  void getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loggedInName = prefs.getString(loginUsernamePrefKey)!;
  }

  Future<String> getLoggedInId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      loggedInId = prefs.getString(loginPrefKey) ?? '';
    });

    return loggedInId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 24,
        ),
        child: Column(
          children: [
            _buildSearchField(),
            const SizedBox(height: 16),
            BlocBuilder<ContactCubit, ContactState>(
              bloc: widget.contactCubit,
              builder: (context, state) {
                if (state is ContactLoaded) {
                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await widget.contactCubit.getContactData();

                        widget.contactCubit.getAndSortContactsAlphabetically();
                      },
                      child: ListView.builder(
                        itemCount: state.sortedKeys.length,
                        itemBuilder: (context, index) {
                          String letter = state.sortedKeys[index];

                          return buildContactGroup(
                              letter, state.groupedContacts[letter]!);
                        },
                      ),
                    ),
                  );
                } else if (state is ContactLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return const Center(child: Text('No contacts found.'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  TextField _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search your contact list...',
        hintStyle: const TextStyle(color: Color(0xFF7F7F7F)),
        suffixIcon: const Icon(Icons.search),
        fillColor: Colors.grey[200],
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: AppThemeColor.lightGray,
            )),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppThemeColor.bluePrimary),
        ),
      ),
      onChanged: (value) {
        widget.contactCubit.searchContact(value);
      },
    );
  }

  Widget buildContactGroup(String groupLetter, List<Contact> contacts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            groupLetter,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppThemeColor.bluePrimary,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Divider(),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return _buildContactCard(contact);
          },
        ),
      ],
    );
  }

  Widget _buildContactCard(Contact contact) {
    return InkWell(
      onTap: () async {
        final updatedData = await Get.to<String>(
          () => UpdateContactDetail(
            contact: contact,
            contactCubit: widget.contactCubit,
            loggedInId: loggedInId,
          ),
        );

        if (updatedData != null) {
          if (contact.id == loggedInId) {
            setState(() async {
              loggedInName = updatedData;

              // Saved logged in data user
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString(loginPrefKey, contact.id);
              await prefs.setString(loginUsernamePrefKey,
                  '${contact.firstName} ${contact.lastName}');
              await prefs.setString(loginEmailPrefKey, contact.email!);
              await prefs.setString(loginDobPrefKey, contact.dob!);
            });
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: AppThemeColor.bluePrimary,
            child: Text(
              contact.firstName[0],
              style: TextStyle(color: AppThemeColor.white),
            ),
          ),
          title: Row(
            children: [
              Text(
                  "${contact.firstName} ${contact.lastName}${(loggedInName == '${contact.firstName} ${contact.lastName}') ? " (you)" : ""}"),
            ],
          ),
        ),
      ),
    );
  }
}
