import 'package:ecommerce_store_app/constant/my_validators.dart';
import 'package:ecommerce_store_app/constant/styls.dart';
import 'package:ecommerce_store_app/services/asset_manager.dart';
import 'package:ecommerce_store_app/widget/Custom_TextFormField%20.dart';
import 'package:ecommerce_store_app/widget/colors_text.dart';
import 'package:ecommerce_store_app/widget/custom_bottom.dart';
import 'package:ecommerce_store_app/widget/loading_manager.dart';
import 'package:ecommerce_store_app/widget/my_app_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/ForgotPasswordScreen';
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController _emailController;
  late final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _emailController.dispose();
    }
    super.dispose();
  }

  Future<void> _forgetPassFCT() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      if (_emailController.text.isEmpty ||
          !_emailController.text.contains('@')) {
        MyAppWornaing.showErrorORWarningDialog(
          context: context,
          subtitle: "Please Enter Your Email",
          fct: () {},
        );
      } else {
        setState(() {
          _isLoading = true;
        });
      }
      try {
        await auth.sendPasswordResetEmail(
            email: _emailController.text.toLowerCase());
      } on FirebaseAuthException catch (error) {
        await MyAppWornaing.showErrorORWarningDialog(
          context: context,
          subtitle: "An error has been occured ${error.message}",
          fct: () {},
        );
      } catch (error) {
        await MyAppWornaing.showErrorORWarningDialog(
          context: context,
          subtitle: "An error has been occured $error",
          fct: () {},
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const ColorText(
          text: 'Shop Smart',
          fontSize: 22,
        ),
      ),
      body: LoadingManager(
        isLoading: _isLoading,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: ListView(
              // shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              physics: const BouncingScrollPhysics(),
              children: [
                // Section 1 - Header
                const SizedBox(
                  height: 10,
                ),
                Image.asset(
                  AssetsManager.forgotPassword,
                  width: size.width * 0.6,
                  height: size.width * 0.6,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Forgot password',
                  style: Styles.textStyle22,
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Please enter the email address you\'d like your password reset information sent to',
                  style: Styles.textStyle14,
                ),
                const SizedBox(
                  height: 40,
                ),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: _emailController,
                        hintText: "youremail@email.com",
                        prefixIcon: IconlyLight.message,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          return MyValidators.emailValidator(value);
                        },
                        filled: true,
                        onFieldSubmitted: (_) {
                          // Move focus to the next field when the "next" button is pressed
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                SizedBox(
                  height: 65,
                  child: CustomElevatedButton(
                    buttonText: "Request link",
                    onPressed: () async {
                      try {
                        await _forgetPassFCT();
                      } catch (error) {
                        print('حدث خطأ: $error');
                      }
                    },
                    height: 50,
                    backgroundColor: Colors.blueAccent,
                    textStyle:
                        const TextStyle(fontSize: 16, color: Colors.white),
                    icon: const Icon(IconlyBold.send),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
