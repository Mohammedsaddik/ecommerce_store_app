import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:ecommerce_store_app/Screens/root_screen/root_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 300,
      splash: 'assets/images/bag/order.png',
      splashIconSize: 300,
      nextScreen: const RootScreen(),
      backgroundColor: Colors.orangeAccent,
      curve: Curves.bounceInOut,
      splashTransition: SplashTransition.slideTransition,
      //pageTransitionType: PageTransitionType.bottomToTop,
    );
  }
}
