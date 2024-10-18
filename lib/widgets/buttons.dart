import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Buttons {
  static Widget buildPrimaryButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
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
        onPressed: onPressed,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
