import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_store_app/Screens/root_screen/root_screen.dart';
import 'package:ecommerce_store_app/constant/AppFunction.dart';
import 'package:ecommerce_store_app/widget/custom_bottom.dart';
import 'package:ecommerce_store_app/widget/my_app_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';

class GoogleButton extends StatefulWidget {
  const GoogleButton({
    super.key,
  });

  @override
  State<GoogleButton> createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<GoogleButton> {
  final GoogleSignIn gSignIn = GoogleSignIn();

  Future<void> googleSignIn() async {
    try {
      final GoogleSignInAccount? account = await gSignIn.signIn();

      if (account != null) {
        // Retrieve the authentication token
        final GoogleSignInAuthentication authentication =
            await account.authentication;

        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: authentication.accessToken,
          idToken: authentication.idToken,
        );
        final authResult =
            await FirebaseAuth.instance.signInWithCredential(authCredential);

        if (authResult.additionalUserInfo!.isNewUser) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user!.uid)
              .set({
            'userId': authResult.user!.uid,
            'userName': authResult.user!.displayName,
            'userImage': authResult.user!.photoURL,
            'userEmail': authResult.user!.email,
            'createdAt': Timestamp.now(),
            'userCart': [],
            'userWishlist': [],
          }).then((value) async {
            await AppFunction.pushAndRemove(context, const RootScreen());
          });
        }
        await FirebaseAuth.instance.signInWithCredential(authCredential).then(
            (value) async =>
                await AppFunction.pushAndRemove(context, const RootScreen()));
      } else {
        Fluttertoast.showToast(
          msg: "Google Sign-In canceled",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
        );
        // User canceled the sign-in process
        print('Google Sign-In canceled by user');
      }
    } on FirebaseAuthException catch (error) {
      await MyAppWornaing.showErrorORWarningDialog(
        context: context,
        subtitle: "An error has been occured ${error.message}",
        fct: () {
          Navigator.pop(context);
        },
      );
    } catch (error) {
      await MyAppWornaing.showErrorORWarningDialog(
        context: context,
        subtitle: "An error has been occured $error",
        fct: () {
          Navigator.pop(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomElevatedButton(
        buttonText: 'Sign in with google',
        textStyle: const TextStyle(fontSize: 14, color: Colors.black),
        onPressed: () async {
          await googleSignIn();
        },
        backgroundColor: const Color.fromARGB(255, 235, 235, 235),
        icon: const Icon(
          Ionicons.logo_google,
          color: Colors.red,
        ),
      ),
    );
  }
}
