import 'package:contact_app/cubits/contact/contact_cubit.dart';
import 'package:contact_app/models/contact.dart';
import 'package:contact_app/utils/color.dart';
import 'package:contact_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class UpdateContactDetail extends StatefulWidget {
  final Contact contact; // The contact to update
  final ContactCubit contactCubit;
  final String loggedInId;
  final bool isProfile;

  const UpdateContactDetail({
    super.key,
    required this.contact,
    required this.contactCubit,
    required this.loggedInId,
    this.isProfile = false,
  });

  @override
  State<UpdateContactDetail> createState() => _UpdateContactDetailState();
}

class _UpdateContactDetailState extends State<UpdateContactDetail> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

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

    firstNameController.text = widget.contact.firstName;
    lastNameController.text = widget.contact.lastName;
    emailController.text = widget.contact.email ?? '';
    dateController.text = widget.contact.dob ?? '';
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
          child: Form(
            key: _formKey,
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
                    if (_formKey.currentState!.validate()) {
                      if (widget.isProfile) {
                        Get.back(
                          result: Contact(
                            id: widget.contact.id,
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            email: emailController.text,
                            dob: dateController.text,
                          ),
                        );
                      } else {
                        widget.contactCubit.updateContactDetail(
                          Contact(
                            id: widget.contact.id,
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            email: emailController.text,
                            dob: dateController.text,
                          ),
                        );

                        // Return the updated contact to the previous screen
                        Get.back(
                            result:
                                '${firstNameController.text} ${lastNameController.text}');
                      }
                    }
                  },
                ),
                const SizedBox(height: 20),
                if (widget.contact.id != widget.loggedInId)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async {
                        widget.contactCubit.removeContact(Contact(
                          id: widget.contact.id,
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          email: emailController.text,
                          dob: dateController.text,
                        ));

                        Fluttertoast.showToast(
                            msg:
                                '${firstNameController.text} ${lastNameController.text} succesfully deleted');

                        Get.back();
                      },
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Field must not null!';
              }
              return null;
            },
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
