import 'package:ecommerce_store_app/constant/styls.dart';
import 'package:ecommerce_store_app/services/asset_manager.dart';
import 'package:ecommerce_store_app/widget/subtitle_text.dart';
import 'package:ecommerce_store_app/widget/title_text.dart';
import 'package:flutter/material.dart';

class MyAppWornaing {
  static Future<void> showErrorORWarningDialog({
    required BuildContext context,
    required String subtitle,
    required Function fct,
    bool isError = true,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  AssetsManager.warning,
                  height: 60,
                  width: 60,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                SubtitleTextWidget(
                  label: subtitle,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: !isError,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const SubtitleTextWidget(
                          label: "Cancel",
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        fct();
                        Navigator.pop(context);
                      },
                      child: const SubtitleTextWidget(
                        label: "OK",
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  static Future<void> imagePickerDialog({
    required BuildContext context,
    required Function cameraFCT,
    required Function galleryFCT,
    required Function removeFCT,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0), // تحديد نصف قطر الحدود
          ),
          backgroundColor: Colors.grey[200], // تحديد لون الخلفية
          title: const Center(
            child: TitlesTextWidget(
              label: "Choose option",
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Container(
                  height: 4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.grey,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    cameraFCT();
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.camera,
                    size: 30,
                  ),
                  label: const Text(
                    "Camera",
                    style: Styles.textStyle18,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    galleryFCT();
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.image,
                    size: 30,
                  ),
                  label: const Text(
                    "Gallery",
                    style: Styles.textStyle18,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    removeFCT();
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.remove_circle,
                    size: 30,
                  ),
                  label: const Text(
                    "Remove",
                    style: Styles.textStyle18,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
