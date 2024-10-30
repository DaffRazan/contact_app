import 'package:contact_app/cubits/contact/contact_cubit.dart';
import 'package:contact_app/models/contact.dart';
import 'package:contact_app/screens/update_contact_screen.dart';
import 'package:contact_app/utils/color.dart';
import 'package:contact_app/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final ContactCubit contactCubit;

  const ProfileScreen({super.key, required this.contactCubit});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String loggedInUserName = "";
  String loggedInEmail = '';
  String loggedInDob = '';
  String firstName = '';
  String secondName = '';
  String loggedInId = '';

  @override
  void initState() {
    super.initState();
    _loadLoggedInUser();
  }

  Future<void> _loadLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedInUserName = prefs.getString(loginUsernamePrefKey) ?? 'Guest';
      loggedInEmail = prefs.getString(loginEmailPrefKey) ?? '';
      loggedInDob = prefs.getString(loginDobPrefKey) ?? '';
      loggedInId = prefs.getString(loginPrefKey) ?? '';

      // Split the string into a list of words
      List<String> words = loggedInUserName.split(' ');

      // Get the first and second words
      firstName = words.isNotEmpty ? words[0] : '';
      secondName = words.length > 1 ? words[1] : '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 16,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppThemeColor.bluePrimary,
                ),
                child: Text(
                  loggedInUserName.isNotEmpty ? loggedInUserName[0] : '',
                  style: TextStyle(
                    fontSize: 40,
                    color: AppThemeColor.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(loggedInUserName),
              const SizedBox(height: 10),
              Text(loggedInEmail),
              const SizedBox(height: 10),
              Text(loggedInDob),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  onPressed: () async {
                    //TODO Update profile data bugged

                    final updatedContact = await Get.to<Contact>(
                      () => UpdateContactDetail(
                        contactCubit: widget.contactCubit,
                        contact: Contact(
                          id: loggedInId,
                          firstName: firstName,
                          lastName: secondName,
                          dob: loggedInDob,
                          email: loggedInEmail,
                        ),
                        loggedInId: loggedInId,
                        isProfile: true,
                      ),
                    );

                    if (updatedContact != null) {
                      _updateContact(updatedContact);
                    }
                  },
                  child: Text(
                    'Update my detail',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateContact(Contact updatedContact) {
    setState(() {
      loggedInUserName =
          '${updatedContact.firstName} ${updatedContact.lastName}';
      loggedInEmail = updatedContact.email ?? '';
      loggedInDob = updatedContact.dob ?? '';

      firstName = updatedContact.firstName;
      secondName = updatedContact.lastName;
    });
  }
}
