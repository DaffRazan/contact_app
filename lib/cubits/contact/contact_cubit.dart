import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:contact_app/models/contact.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart' as root_bundle;

part 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  ContactCubit() : super(ContactInitial());

  List<Contact> _originalContacts = []; // To keep the original contacts
  List<Contact> _filteredContacts = []; // To store the filtered contacts
  List<Contact> contacts = [];

  Future<void> getContactData() async {
    final jsonString =
        await root_bundle.rootBundle.loadString('assets/data.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);

    _originalContacts =
        jsonResponse.map((data) => Contact.fromJson(data)).toList();
  }

  Future<List<Contact>> filterContact(String query) async {
    List<Contact> filteredContacts = _originalContacts
        .where((contact) => ('${contact.firstName} ${contact.lastName}')
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

    return filteredContacts;
  }

  // Method to load and sort contacts
  void getAndSortContactsAlphabetically() async {
    emit(ContactLoading());

    await getContactData();

    contacts = _originalContacts;

    // Sort contacts alphabetically by first letter
    Map<String, List<Contact>> groupedContacts = {};
    for (var contact in contacts) {
      String firstLetter = contact.firstName[0].toUpperCase();
      if (groupedContacts[firstLetter] == null) {
        groupedContacts[firstLetter] = [];
      }
      groupedContacts[firstLetter]!.add(contact);
    }

    // Sort the keys alphabetically
    var sortedKeys = groupedContacts.keys.toList()..sort();

    // Emit the new state with sorted and grouped contacts
    emit(ContactLoaded(groupedContacts, sortedKeys));
  }

  // Search contact
  void searchContact(String query) async {
    emit(ContactLoading());

    if (query.isEmpty) {
      contacts = _originalContacts;
    } else {
      _filteredContacts = await filterContact(query);
      contacts = _filteredContacts;
    }

    // Sort contacts alphabetically by first letter
    Map<String, List<Contact>> groupedContacts = {};
    for (var contact in contacts) {
      String firstLetter = contact.firstName[0].toUpperCase();
      if (groupedContacts[firstLetter] == null) {
        groupedContacts[firstLetter] = [];
      }
      groupedContacts[firstLetter]!.add(contact);
    }

    // Sort the keys alphabetically
    var sortedKeys = groupedContacts.keys.toList()..sort();

    // Emit the new state with sorted and grouped contacts
    emit(ContactLoaded(groupedContacts, sortedKeys));
  }

  // adding new data
  void addNewContact(Contact newContact) {
    emit(ContactLoading());

    _originalContacts.add(newContact);
    contacts = _originalContacts;

    // Sort contacts alphabetically by first letter
    Map<String, List<Contact>> groupedContacts = {};
    for (var contact in contacts) {
      String firstLetter = contact.firstName[0].toUpperCase();
      if (groupedContacts[firstLetter] == null) {
        groupedContacts[firstLetter] = [];
      }
      groupedContacts[firstLetter]!.add(contact);
    }

    // Sort the keys alphabetically
    var sortedKeys = groupedContacts.keys.toList()..sort();

    // Emit the new state with updated, sorted, and grouped contacts
    emit(ContactLoaded(groupedContacts, sortedKeys));
  }

  // updating data contact
  void updateContactDetail(Contact updatedContact) {
    emit(ContactLoading());

    // Find the index of the contact to be updated
    int index = _originalContacts
        .indexWhere((contact) => contact.id == updatedContact.id);

    if (index != -1) {
      // Update the contact in the original contacts list
      _originalContacts[index] = updatedContact;

      // Sort contacts alphabetically by first letter
      Map<String, List<Contact>> groupedContacts = {};
      for (var contact in contacts) {
        String firstLetter = contact.firstName[0].toUpperCase();
        if (groupedContacts[firstLetter] == null) {
          groupedContacts[firstLetter] = [];
        }
        groupedContacts[firstLetter]!.add(contact);
      }

      // Sort the keys alphabetically
      var sortedKeys = groupedContacts.keys.toList()..sort();

      // Emit the new state with updated, sorted, and grouped contacts
      emit(ContactLoaded(groupedContacts, sortedKeys));
    } else {
      // If the contact doesn't exist, handle the error or show a message
      print("Error: Contact not found.");
    }
  }

  void removeContact(Contact updatedContact) {
    emit(ContactLoading());

    int index = _originalContacts
        .indexWhere((contact) => contact.id == updatedContact.id);

    if (index != -1) {
      _originalContacts.removeAt(index);
    }

    contacts = _originalContacts;

    // Sort contacts alphabetically by first letter
    Map<String, List<Contact>> groupedContacts = {};
    for (var contact in contacts) {
      String firstLetter = contact.firstName[0].toUpperCase();
      if (groupedContacts[firstLetter] == null) {
        groupedContacts[firstLetter] = [];
      }
      groupedContacts[firstLetter]!.add(contact);
    }

    // Sort the keys alphabetically
    var sortedKeys = groupedContacts.keys.toList()..sort();

    // Emit the new state with updated, sorted, and grouped contacts
    emit(ContactLoaded(groupedContacts, sortedKeys));
  }
}
