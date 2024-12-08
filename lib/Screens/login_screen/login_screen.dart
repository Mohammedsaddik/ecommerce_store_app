import 'package:ecommerce_store_app/Screens/Register_screen/register_screen.dart';
import 'package:ecommerce_store_app/Screens/Register_screen/widget/snack_bar.dart';
import 'package:ecommerce_store_app/Screens/forgot_password_screen/forgot_password.dart';
import 'package:ecommerce_store_app/Screens/login_screen/widget/google_btn.dart';
import 'package:ecommerce_store_app/Screens/root_screen/root_screen.dart';
import 'package:ecommerce_store_app/constant/AppFunction.dart';
import 'package:ecommerce_store_app/constant/my_validators.dart';
import 'package:ecommerce_store_app/widget/Custom_TextFormField%20.dart';
import 'package:ecommerce_store_app/widget/colors_text.dart';
import 'package:ecommerce_store_app/widget/custom_bottom.dart';
import 'package:ecommerce_store_app/widget/loading_manager.dart';
import 'package:ecommerce_store_app/widget/my_app_method.dart';
import 'package:ecommerce_store_app/widget/subtitle_text.dart';
import 'package:ecommerce_store_app/widget/title_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class LoginScreen extends StatefulWidget {
  static const routName = '/LoginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool _isLoading = false;
  final auth = FirebaseAuth.instance;
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    // Focus Nodes
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    // Focus Nodes
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loginFct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      try {
        setState(() {
          _isLoading = true;
        });
        await auth
            .signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            )
            .then((value) =>
                AppFunction.pushAndRemove(context, const RootScreen()));
        ShowSnackBar(context, 'Login Successful');
        if (!mounted) return;

        //Navigator.pushReplacementNamed(context, RootScreen.routName);
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
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: LoadingManager(
          isLoading: _isLoading,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(
                    height: 60.0,
                  ),
                  const ColorText(
                    text: 'ShopSmart',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: TitlesTextWidget(label: "Welcome"),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: TitlesTextWidget(
                        color: Colors.grey,
                        fontSize: 12,
                        label:
                            "Let,s get you loggod in so you can start exploring."),
                  ),
                  const SizedBox(
                    height: 45.0,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          hintText: "Email address",
                          prefixIcon: IconlyLight.message,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          nextFocusNode: _passwordFocusNode,
                          validator: (value) {
                            return MyValidators.emailValidator(value);
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_passwordFocusNode);
                          },
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        CustomTextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          hintText: "Password",
                          obscureText: obscureText,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: Icon(
                                obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          prefixIcon: IconlyLight.lock,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          nextFocusNode: _passwordFocusNode,
                          validator: (value) {
                            return MyValidators.passwordValidator(value);
                          },
                          onFieldSubmitted: (value) {
                            _loginFct();
                          },
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        SizedBox(
                          height: 65,
                          child: CustomElevatedButton(
                            buttonText: "Log In",
                            onPressed: () async {
                              _loginFct();
                            },
                            height: 50,
                            backgroundColor: Colors.blueAccent,
                            textStyle: const TextStyle(
                                fontSize: 16, color: Colors.white),
                            icon: const Icon(
                              Icons.login,
                              size: 30,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, ForgotPasswordScreen.routeName);
                            },
                            child: const SubtitleTextWidget(
                              label: "Forgotten password?",
                              color: Colors.blueAccent,
                              textDecoration: TextDecoration.none,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        const Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Colors.grey,
                                indent: 20,
                                endIndent: 10,
                              ),
                            ),
                            Text(
                              "or",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Colors.grey,
                                indent: 10,
                                endIndent: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        SubtitleTextWidget(
                          label: "OR connect using".toUpperCase(),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: [
                            const GoogleButton(),
                            const SizedBox(width: 10), // المسافة بين الزرين
                            CustomElevatedButton(
                              buttonText: 'Guest?',
                              textStyle: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, RootScreen.routName);
                              },
                              backgroundColor:
                                  const Color.fromARGB(255, 235, 235, 235),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SubtitleTextWidget(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              label: "Don't have an account?",
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, RegisterScreen.routName);
                              },
                              child: const SubtitleTextWidget(
                                label: "Sign up",
                                textDecoration: TextDecoration.underline,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
