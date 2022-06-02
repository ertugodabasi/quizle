import 'package:flutter/material.dart';
import 'package:quizle/constants.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextEditingController? controller;
  const CustomTextField({
    Key? key,
    required this.hintText,
    this.controller,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          filled: true,
          fillColor: kTextFieldFillColor,
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)))),
    );
  }
}
