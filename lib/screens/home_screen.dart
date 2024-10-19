import 'package:contact_app/screens/add_contact_screen.dart';
import 'package:contact_app/screens/contact_screen.dart';
import 'package:contact_app/screens/login_screen.dart';
import 'package:contact_app/screens/profile_screen.dart';
import 'package:contact_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ContactScreen(),
    const ProfileScreen(),
  ];

  final List<String> _pageTitle = [
    'My Contacts',
    'My Profile',
  ];

  // Method to handle tap on the bottom navigation bar
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/ic_unactive_contact.svg'),
            label: '',
            activeIcon: SvgPicture.asset('assets/icons/ic_contact.svg'),
          ),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset('assets/icons/ic_human.svg'),
            label: '',
            icon: SvgPicture.asset('assets/icons/ic_unactive_human.svg'),
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
      floatingActionButton: Visibility(
        visible: (_currentIndex == 0),
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: AppThemeColor.bluePrimary,
          onPressed: () {
            Get.to(() => const AddContactScreen());
          },
          child: Icon(
            Icons.add,
            color: AppThemeColor.white,
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          _pageTitle[_currentIndex],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        actions: (_currentIndex == 1)
            ? [
                TextButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.clear();

                    // Navigate back to the login screen
                    Get.offAll(() => const LoginScreen());
                  },
                  child: Text(
                    'Logout',
                    style: GoogleFonts.poppins(
                      color: AppThemeColor.bluePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ]
            : [],
      ),
      body: _pages[_currentIndex],
    );
  }
}
