import 'dart:convert';

import 'package:contact_app/models/contact.dart';
import 'package:contact_app/screens/home_screen.dart';
import 'package:contact_app/utils/color.dart';
import 'package:contact_app/utils/const.dart';
import 'package:contact_app/utils/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' as rootBundle;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userIdController = TextEditingController();
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null) {
      Get.off(const HomeScreen());
    }
  }

  Future<void> login() async {
    String enteredId = userIdController.text.trim();

    final jsonString =
        await rootBundle.rootBundle.loadString('assets/data.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);

    List<Contact> users =
        jsonResponse.map((json) => Contact.fromJson(json)).toList();

    Contact? loggedInUser = users.cast<Contact?>().firstWhere(
          (user) => user?.id == enteredId,
          orElse: () => null,
        );

    if (loggedInUser != null) {
      // Store user ID in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(loginPrefKey, loggedInUser.id);
      await prefs.setString(loginUsernamePrefKey,
          '${loggedInUser.firstName} ${loggedInUser.lastName}');
      await prefs.setString(loginEmailPrefKey, loggedInUser.email!);
      await prefs.setString(loginDobPrefKey, loggedInUser.dob!);

      // Navigate to the home screen
      Get.offAll(() => const HomeScreen());
    } else {
      setState(() {
        errorMessage = "User not found. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 32,
            horizontal: 16,
          ),
          child: GestureDetector(
            onTap: () {
              Utils.hideKeyboard(context);
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi There!',
                  style: GoogleFonts.poppins(
                    color: AppThemeColor.bluePrimary,
                  ),
                ),
                const Text('Please login to see your contact list'),
                const SizedBox(
                  height: 40,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'User ID',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text: ' *',
                            style: GoogleFonts.poppins(
                              color: AppThemeColor.red,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: userIdController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppThemeColor.lightGray,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: AppThemeColor.bluePrimary),
                        ),
                        contentPadding: const EdgeInsets.all(24),
                        prefixIcon: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: SvgPicture.asset(
                            'assets/icons/ic_human.svg',
                            height: 20,
                            width: 20,
                          ),
                        ),
                      ),
                    ),
                    if (errorMessage.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(errorMessage,
                          style: TextStyle(color: AppThemeColor.red)),
                    ]
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
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
                    onPressed: login,
                    child: Text(
                      'Login',
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
      ),
    );
  }
}
