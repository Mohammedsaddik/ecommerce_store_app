import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.imagePath,
    required this.text,
    required this.function,
    this.fontSize = 18.0, // تحديد حجم الخط الافتراضي
  });

  final String imagePath, text;
  final Function function;
  final double fontSize; // إضافة خاصية لحجم الخط

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        function();
      },
      leading: Image.asset(
        imagePath,
        height: 30,
      ),
      title: Text(
        text,
        style: TextStyle(fontSize: fontSize), // تعيين حجم الخط هنا
      ),
      trailing: const Icon(IconlyLight.arrow_right_2),
    );
  }
}
