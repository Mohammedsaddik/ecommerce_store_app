import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Color backgroundColor;
  final TextStyle textStyle;
  final Icon? icon;
  final double borderRadius; // إضافة الخاصية للتحكم في الزاوية المستديرة

  const CustomElevatedButton({
    required this.buttonText,
    required this.onPressed,
    this.width = 220,
    this.height = 60,
    this.backgroundColor = Colors.blue,
    this.textStyle = const TextStyle(fontSize: 30, color: Colors.red),
    this.icon,
    this.borderRadius = 30, // قيمة افتراضية للزاوية المستديرة
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: const EdgeInsets.all(20),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) icon!,
          SizedBox(
            width: icon != null ? 10 : 0,
          ),
          Text(
            buttonText,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
