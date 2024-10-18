import 'package:contact_app/screens/update_contact_screen.dart';
import 'package:contact_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                  'AS',
                  style: TextStyle(
                    fontSize: 40,
                    color: AppThemeColor.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text('Avi Savannah'),
              const SizedBox(height: 10),
              const Text('avisavvanah@gmail.com'),
              const SizedBox(height: 10),
              const Text('26/6/1998'),
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
                  onPressed: () {
                    Get.to(() => const UpdateContactDetail());
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
}
