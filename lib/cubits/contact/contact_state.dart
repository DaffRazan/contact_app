part of 'contact_cubit.dart';

@immutable
sealed class ContactState {}

final class ContactInitial extends ContactState {}

final class ContactLoading extends ContactState {}

final class ContactLoaded extends ContactState {
  final Map<String, List<Contact>> groupedContacts;
  final List<String> sortedKeys;

  ContactLoaded(this.groupedContacts, this.sortedKeys);
}
