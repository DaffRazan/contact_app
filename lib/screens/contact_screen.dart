import 'package:contact_app/utils/color.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 24,
        ),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search your contact list...',
                hintStyle: const TextStyle(color: Color(0xFF7F7F7F)),
                suffixIcon: const Icon(Icons.search),
                fillColor: Colors.grey[200],
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppThemeColor.lightGray,
                    )),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppThemeColor.bluePrimary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
