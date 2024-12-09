import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextStyle textStyle;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.textStyle,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: textStyle.copyWith(fontWeight: FontWeight.bold), 
        ),
        const SizedBox(height: 8), 
        Container(
          child: TextFormField(
            controller: controller,
            style: textStyle,
            validator: validator,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 169, 169, 169), 
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 16,
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
      ],
    );
  }
}
