import 'package:flutter/material.dart';
import 'package:flutter_application_ticket/controller/reacessticketnoController.dart';
import 'package:flutter_application_ticket/widget/customTextField.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController ticketnumber = TextEditingController();
  final TextEditingController customername = TextEditingController();
  final TextEditingController customertel = TextEditingController();
  final TextEditingController customeremail = TextEditingController();
  final ReAccessTicketNoController _controller = ReAccessTicketNoController();

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('กำลังตรวจสอบ...')),
      // );

      final response = await _controller.reAccessTicket(
        ticketNo: ticketnumber.text,
        cusName: customername.text,
        cusTel: customertel.text,
        cusEmail: customeremail.text,
      );

      if (response.containsKey("error")) {
        _showDialog(
          message: response["error"],
          icon: Icons.error,
          iconColor: Colors.red,
        );
      } else {
        final String statusName = response["statusName"] ?? "ไม่ทราบสถานะ";
        final bool success = response["success"] ?? false;

        if (success) {
          _showDialog(
            message: "$statusName",
            icon: Icons.check_circle,
            iconColor: Colors.green,
          );
        } else {
          _showDialog(
            message: "ไม่สำเร็จ",
            icon: Icons.cancel,
            iconColor: Colors.red,
          );
        }
      }
    }
  }

  void _showDialog({
    required String message,
    required IconData icon,
    required Color iconColor,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Icon(icon, size: 50, color: iconColor),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 95, 138, 192),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text('ตกลง'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 248, 255),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  'อนุญาตให้เข้า',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Center(
                child: Text(
                  'กรุณากรอกข้อมูลของลูกค้า\nเพื่อทำการอนุญาตให้เข้า\n',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 132, 132, 132),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              CustomTextField(
                controller: ticketnumber,
                labelText: 'เลขที่ตั๋ว *',
                hintText: '',
                textStyle: const TextStyle(fontSize: 14),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกเลขที่ตั๋ว';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: customername,
                labelText: 'ชื่อลูกค้า *',
                hintText: '',
                textStyle: const TextStyle(fontSize: 14),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อลูกค้า';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: customertel,
                labelText: 'เบอร์ลูกค้า *',
                hintText: '',
                textStyle: const TextStyle(fontSize: 14),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกเบอร์ลูกค้า';
                  } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'กรอกเป็นตัวเลขเท่านั้น ไม่เกิน 10 ตัว';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: customeremail,
                labelText: 'อีเมลลูกค้า',
                hintText: '',
                textStyle: const TextStyle(fontSize: 14),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'กรุณากรอกอีเมลให้ถูกต้อง';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 95, 138, 192),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text('ยืนยัน', style: TextStyle(fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
