import 'package:flutter/material.dart';
import 'package:flutter_application_ticket/screen/checkticket.dart';
import 'package:flutter_application_ticket/screen/form.dart';
import 'package:flutter_application_ticket/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions() {
    return <Widget>[
      const CheckTicketScreen(),
      const FormScreen(),
      const LoginScreen(),
    ];
  }

  void _onItemTapped(int index) async {
    if (index == 2) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('authToken');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions()[_selectedIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code),
              label: 'ตรวจตั๋ว',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check),
              label: 'อนุญาติให้เข้า',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'ออกจากระบบ',
            ),
          ],
          backgroundColor: const Color.fromARGB(255, 229, 241, 255),
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF0f528c),
          unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
