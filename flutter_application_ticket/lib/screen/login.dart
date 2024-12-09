import 'package:flutter/material.dart';
import 'package:flutter_application_ticket/controller/pinloginController.dart';
import 'package:flutter_application_ticket/screen/homepage.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final pinLoginController _controller = pinLoginController();

  String _otpInput = '';
  String _otpConfirm = '';

  bool _showOtpFields = true;

  void _resetOtpFields() {
    setState(() {
      _showOtpFields = false;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _showOtpFields = true;
        _otpInput = '';
        _otpConfirm = '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 248, 255),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'เข้าสู่ระบบ',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'กรอกรหัส OTP',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Kanit',
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_showOtpFields)
              OtpTextField(
                numberOfFields: 6,
                fieldWidth: 45,
                borderColor: Colors.black,
                showFieldAsBox: true,
                borderRadius: BorderRadius.circular(20),
                fillColor: Colors.white,
                filled: true,
                onCodeChanged: (String code) {},
                onSubmit: (String otp) {
                  setState(() {
                    _otpInput = otp;
                  });
                },
              ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'ยืนยัน OTP',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Kanit',
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_showOtpFields)
              OtpTextField(
                numberOfFields: 6,
                fieldWidth: 45,
                borderColor: Colors.black,
                showFieldAsBox: true,
                borderRadius: BorderRadius.circular(20),
                fillColor: Colors.white,
                filled: true,
                onCodeChanged: (String code) {},
                onSubmit: (String otp) {
                  setState(() {
                    _otpConfirm = otp;
                  });
                },
              ),
            const SizedBox(height: 50),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (_otpInput.isEmpty || _otpConfirm.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('กรุณากรอกและยืนยัน OTP ให้ถูกต้อง')),
                    );
                  } else if (_otpInput != _otpConfirm) {
                    _resetOtpFields();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('รหัส OTP ไม่ตรงกัน')),
                    );
                  } else {
                    final isVerified = await _controller.verifyPin(_otpInput);
                    if (isVerified) {
                      final prefs = await SharedPreferences.getInstance();
                      final token = prefs.getString('authToken'); // ดึง Token
                      print('Logged in Token: $token');

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePageScreen(),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('เข้าสู่ระบบสำเร็จ')),
                      );
                    } else {
                      _resetOtpFields();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('OTP ไม่ถูกต้อง')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 95, 138, 192),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'ดำเนินการต่อ',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Kanit',
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
