import 'package:contact_app/utils/color.dart';
import 'package:contact_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contact Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 1,
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
                  child: SvgPicture.asset('assets/icons/ic_human.svg'),
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
              ),
              const SizedBox(height: 17),
              _buildTextForm(
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
                hintText: 'Enter email..',
                label: 'Email',
                iconPath: 'assets/icons/ic_email.svg',
              ),
              const SizedBox(height: 17),
              _buildTextForm(
                hintText: 'Enter birthday..',
                label: 'Date of Birth',
                iconPath: 'assets/icons/ic_calendar.svg',
              ),
              const SizedBox(height: 170),
              Buttons.buildPrimaryButton(
                label: 'Save',
                onPressed: () {},
              ),
              const SizedBox(height: 20),
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
            prefixIcon: SvgPicture.asset(
              iconPath,
              height: 6,
              width: 6,
            ),
          ),
        ),
      ],
    );
  }
}
