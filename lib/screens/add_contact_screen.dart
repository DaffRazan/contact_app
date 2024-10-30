import 'dart:math';

import 'package:contact_app/cubits/contact/contact_cubit.dart';
import 'package:contact_app/models/contact.dart';
import 'package:contact_app/utils/color.dart';
import 'package:contact_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddContactScreen extends StatefulWidget {
  final ContactCubit contactCubit;

  const AddContactScreen({super.key, required this.contactCubit});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final List<Map<String, String>> contacts = []; // List to hold contact data
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Random _random = Random();
  String _randomString = '';

  @override
  void initState() {
    super.initState();
    generateRandomString(24);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    dateController.dispose();
    emailController.dispose();
    super.dispose();
  }

  String? _errorText;

  Future<void> _selectDate(BuildContext context) async {
    // Show the date picker dialog
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text = DateFormat('d/M/yyyy').format(pickedDate);
      });
    }
  }

  void _validateEmail(String value) {
    // Regular expression for validating email
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    // Check if the email matches the regex
    if (!emailRegex.hasMatch(value)) {
      setState(() {
        _errorText = 'Please enter a valid email address';
      });
    } else {
      setState(() {
        _errorText = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contact Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(26),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppThemeColor.bluePrimary,
                    ),
                    child: (firstNameController.text.isNotEmpty)
                        ? Text(
                            firstNameController.text[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 40,
                              color: AppThemeColor.white,
                            ),
                          )
                        : SvgPicture.asset(
                            'assets/icons/ic_human.svg',
                            color: AppThemeColor.white,
                            height: 40,
                            width: 40,
                          ),
                  ),
                ),
                const SizedBox(height: 37),
                Text(
                  'Main Information',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: AppThemeColor.bluePrimary,
                  ),
                ),
                const Divider(),
                _buildTextForm(
                  hintText: 'Enter first name..',
                  label: 'First Name',
                  iconPath: 'assets/icons/ic_human.svg',
                  controller: firstNameController,
                  textInputType: TextInputType.name,
                ),
                const SizedBox(height: 17),
                _buildTextForm(
                  hintText: 'Enter last name..',
                  label: 'Last Name',
                  iconPath: 'assets/icons/ic_human.svg',
                  controller: lastNameController,
                  textInputType: TextInputType.name,
                ),
                const SizedBox(height: 26),
                Text(
                  'Sub Information',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: AppThemeColor.bluePrimary,
                  ),
                ),
                const Divider(),
                _buildTextForm(
                  hintText: 'Enter email..',
                  label: 'Email',
                  errorText: _errorText ?? '',
                  iconPath: 'assets/icons/ic_email.svg',
                  controller: emailController,
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 17),
                _buildTextForm(
                  hintText: 'Enter birthday..',
                  label: 'Date of Birth',
                  iconPath: 'assets/icons/ic_calendar.svg',
                  controller: dateController,
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 170),
                Buttons.buildPrimaryButton(
                  label: 'Save',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (firstNameController.text.isNotEmpty ||
                          lastNameController.text.isNotEmpty ||
                          dateController.text.isNotEmpty ||
                          dateController.text.isNotEmpty) {
                        setState(() {
                          _randomString = generateRandomString(24);
                        });

                        widget.contactCubit.addNewContact(Contact(
                          id: _randomString,
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          email: emailController.text,
                          dob: dateController.text,
                        ));

                        Get.back();
                      }
                    }
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String generateRandomString(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(
        length, (index) => chars[_random.nextInt(chars.length)]).join();
  }

  Column _buildTextForm({
    required String label,
    required String hintText,
    required String iconPath,
    required TextEditingController controller,
    required TextInputType textInputType,
    String errorText = '',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              TextSpan(
                text: ' *',
                style: GoogleFonts.poppins(
                  color: Colors.red,
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
            controller: controller,
            keyboardType: textInputType,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Field must not null!';
              }
              return null;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppThemeColor.lightGray,
                ),
              ),
              hintText: hintText,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppThemeColor.bluePrimary),
              ),
              contentPadding: const EdgeInsets.all(24),
              prefixIcon: FittedBox(
                fit: BoxFit.scaleDown,
                child: SvgPicture.asset(
                  iconPath,
                  height: 14,
                  width: 14,
                ),
              ),
            ),
            onChanged: (value) {
              if (value != '') {
                setState(() {});
              } else {
                firstNameController.clear();
                setState(() {});
              }
            },
            readOnly: (label == 'Date of Birth') ? true : false,
            onTap:
                (label == 'Date of Birth') ? () => _selectDate(context) : null),
      ],
    );
  }
}
