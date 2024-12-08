import 'package:ecommerce_store_app/constant/styls.dart';
import 'package:ecommerce_store_app/widget/custom_bottom.dart';
import 'package:ecommerce_store_app/widget/subtitle_text.dart';
import 'package:flutter/material.dart';

class EmptyBagWidget extends StatelessWidget {
  const EmptyBagWidget(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.subtitle,
      required this.buttonText});
  final String imagePath, title, subtitle, buttonText;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Image.asset(
                imagePath,
                height: size.height * 0.35,
                width: double.infinity,
              ),
              const SizedBox(
                height: 10,
              ),
              const Center(
                child: Text(
                  'Whoops !',
                  style: Styles.textStyle40,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: SubtitleTextWidget(
                  label: title,
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 20, right: 10),
                  child: SubtitleTextWidget(
                    label: subtitle,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                child: CustomElevatedButton(
                  buttonText: 'Shop Now',
                  onPressed: () {},
                  backgroundColor: Colors.blue,
                  width: 200,
                  height: 60,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
