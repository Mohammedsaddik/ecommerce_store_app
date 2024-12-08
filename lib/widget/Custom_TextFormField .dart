import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FocusNode? nextFocusNode;
  final FormFieldValidator<String>? validator;
  final void Function(String)? onFieldSubmitted;
  final String? field;
  final bool filled; // Make the filled property optional

  const CustomTextFormField({
    super.key,
    required this.controller,
    this.focusNode,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.nextFocusNode,
    this.validator,
    this.onFieldSubmitted,
    this.field,
    this.filled = true, // Provide a default value for the filled property
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          filled: filled,
          fillColor: filled ? Colors.grey[300] : null,
          contentPadding: const EdgeInsets.symmetric(
              vertical: 15, horizontal: 20), // Adjust content padding
          prefix: const SizedBox(width: 3),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Icon(prefixIcon),
          ),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 0, 110, 201),
            ),
          ),
        ),
      ),
    );
  }
}
