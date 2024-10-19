import 'package:contact_app/models/contact.dart';
import 'package:contact_app/utils/color.dart';
import 'package:contact_app/utils/const.dart';
import 'package:contact_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateContactDetail extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String dob;

  const UpdateContactDetail({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dob,
  });

  @override
  State<UpdateContactDetail> createState() => _UpdateContactDetailState();
}

class _UpdateContactDetailState extends State<UpdateContactDetail> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final List<Map<String, String>> contacts = []; // List to hold contact data
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  @override
  void initState() {
    super.initState();
    firstNameController.text = widget.firstName;
    lastNameController.text = widget.lastName;
    emailController.text = widget.email;
    dateController.text = widget.dob;
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
      body: SingleChildScrollView(
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
                  child: Text(
                    widget.firstName[0],
                    style: TextStyle(
                      fontSize: 40,
                      color: AppThemeColor.white,
                    ),
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
                controller: firstNameController,
                textInputType: TextInputType.name,
                hintText: 'Enter first name..',
                label: 'First Name',
                iconPath: 'assets/icons/ic_human.svg',
              ),
              const SizedBox(height: 17),
              _buildTextForm(
                controller: lastNameController,
                textInputType: TextInputType.name,
                hintText: 'Enter last name..',
                label: 'Last Name',
                iconPath: 'assets/icons/ic_human.svg',
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
                controller: emailController,
                hintText: 'Enter email..',
                label: 'Email',
                iconPath: 'assets/icons/ic_email.svg',
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 17),
              _buildTextForm(
                controller: dateController,
                hintText: 'Enter birthday..',
                label: 'Date of Birth',
                iconPath: 'assets/icons/ic_calendar.svg',
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 170),
              Buttons.buildPrimaryButton(
                label: 'Update',
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String userId = prefs.getString(loginPrefKey) ?? '';

                  // Create a new updated contact with the modified data
                  Contact updatedContact = Contact(
                    id: userId,
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    email: emailController.text, // unchanged
                    dob: dateController.text, // unchanged
                  );

                  // Return the updated contact to the previous screen
                  Get.back(result: updatedContact);
                  //
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: AppThemeColor.red,
                    ), // Red border
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // 10 border radius
                    ),
                  ),
                  child: Text(
                    'Remove',
                    style: TextStyle(
                      color: AppThemeColor.red,
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

  Column _buildTextForm({
    required String label,
    required String hintText,
    required String iconPath,
    required TextEditingController controller,
    required TextInputType textInputType,
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
            readOnly: (label == 'Date of Birth') ? true : false,
            onTap:
                (label == 'Date of Birth') ? () => _selectDate(context) : null),
      ],
    );
  }
}
