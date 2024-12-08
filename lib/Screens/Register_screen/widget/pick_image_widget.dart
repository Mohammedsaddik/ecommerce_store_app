import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImageWidget extends StatelessWidget {
  const PickImageWidget({super.key, this.pickedImage, required this.function});

  final XFile? pickedImage;
  final Function function;

  final double scaleFactor = 1.3; // تحديد عامل التكبير هنا
  final double borderRadius = 50; // نصف قطر الحدود هنا

  @override
  Widget build(BuildContext context) {
    double imageSize = borderRadius * 2; // حجم الصورة يكون مضاعف نصف قطر الحدود

    return Transform.scale(
      scale: scaleFactor,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: pickedImage == null
                  ? Container(
                      width: imageSize,
                      height: imageSize,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius),
                        border: Border.all(),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(borderRadius),
                      child: Image(
                        image: FileImage(File(pickedImage!.path)),
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 5,
            child: Material(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.lightBlue,
              child: InkWell(
                splashColor: Colors.red,
                borderRadius: BorderRadius.circular(16.0),
                onTap: () {
                  function();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.add_a_photo_outlined,
                    size: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
