import 'dart:convert';

import 'package:contact_app/models/contact.dart';
import 'package:contact_app/screens/update_contact_screen.dart';
import 'package:contact_app/utils/color.dart';
import 'package:contact_app/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as root_bundle;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List<Contact> contacts = [];

  String searchQuery = "";
  String loggedInName = '';

  @override
  void initState() {
    super.initState();
    loadContactData();
  }

  Future<void> loadContactData() async {
    final jsonString =
        await root_bundle.rootBundle.loadString('assets/data.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);

    setState(() {
      contacts = jsonResponse.map((data) => Contact.fromJson(data)).toList();
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    loggedInName = prefs.getString(loginUsernamePrefKey)!;
  }

  @override
  Widget build(BuildContext context) {
    List<Contact> filteredContacts = contacts
        .where((contact) => ('${contact.firstName} ${contact.lastName}')
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    // Sort contacts alphabetically by first letter
    Map<String, List<Contact>> groupedContacts = {};
    for (var contact in filteredContacts) {
      String firstLetter = contact.firstName[0].toUpperCase();
      if (groupedContacts[firstLetter] == null) {
        groupedContacts[firstLetter] = [];
      }
      groupedContacts[firstLetter]!.add(contact);
    }

    // Sorted alphabetically
    var sortedKeys = groupedContacts.keys.toList()..sort();

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
            Expanded(
              child: ListView.builder(
                itemCount: sortedKeys.length,
                itemBuilder: (context, index) {
                  String letter = sortedKeys[index];
                  List<Contact> contactsForLetter = groupedContacts[letter]!;

                  return buildContactGroup(letter, contactsForLetter);
                },
              ),
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
        setState(() {
          searchQuery = value;
        });
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
        final updatedContact = await Get.to<Contact>(
          () => UpdateContactDetail(
              firstName: contact.firstName,
              lastName: contact.lastName,
              email: contact.email ?? '',
              dob: contact.dob ?? ''),
        );

        if (updatedContact != null) {
          setState(() {
            contact = updatedContact;
          });
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
