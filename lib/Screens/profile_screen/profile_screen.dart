import 'package:ecommerce_store_app/Screens/inner_screens/viewed_resently.dart';
import 'package:ecommerce_store_app/Screens/inner_screens/wishlist.dart';
import 'package:ecommerce_store_app/Screens/login_screen/login_screen.dart';
import 'package:ecommerce_store_app/Screens/orders_screen/orders_screen.dart';
import 'package:ecommerce_store_app/constant/styls.dart';
import 'package:ecommerce_store_app/localication_classes/language.dart';
import 'package:ecommerce_store_app/localication_classes/language_constants.dart';
import 'package:ecommerce_store_app/main.dart';
import 'package:ecommerce_store_app/models/user_model.dart';
import 'package:ecommerce_store_app/providers/theam_provider.dart';
import 'package:ecommerce_store_app/providers/user_provider.dart';
import 'package:ecommerce_store_app/services/asset_manager.dart';
import 'package:ecommerce_store_app/widget/colors_text.dart';
import 'package:ecommerce_store_app/widget/custom_list.dart';
import 'package:ecommerce_store_app/widget/loading_manager.dart';
import 'package:ecommerce_store_app/widget/my_app_method.dart';
import 'package:ecommerce_store_app/widget/subtitle_text.dart';
import 'package:ecommerce_store_app/widget/title_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  User? user = FirebaseAuth.instance.currentUser;
  bool _isLoading = true;
  UserModel? userModel;

  Future<void> fetchUserInfo() async {
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      userModel = await userProvider.fetchUserInfo();
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

  @override
  void initState() {
    fetchUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const ColorText(text: 'Smart store'),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          // Adjust the padding value as needed
          child: Image.asset(AssetsManager.shoppingCart),
        ),
      ),
      body: LoadingManager(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Visibility(
              visible: user == null ? true : false,
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: TitlesTextWidget(
                    label: "Please login to have ultimate access"),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            userModel == null
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).cardColor,
                            border: Border.all(
                                color: Theme.of(context).colorScheme.surface,
                                width: 3),
                            image: DecorationImage(
                              image: NetworkImage(
                                userModel!.userImage,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitlesTextWidget(label: userModel!.userName),
                            SubtitleTextWidget(
                              label: userModel!.userEmail,
                              color: Colors.blueAccent,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
            const Divider(
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'General',
                    style: Styles.textStyle23,
                  ),
                  user == null
                      ? const SizedBox.shrink()
                      : CustomListTile(
                          imagePath: AssetsManager.orderSvg,
                          text: "All orders",
                          function: () async {
                            await Navigator.pushNamed(
                              context,
                              OrdersScreenFree.routeName,
                            );
                          },
                        ),
                  user == null
                      ? const SizedBox.shrink()
                      : CustomListTile(
                          imagePath: AssetsManager.wishlistSvg,
                          text: "Wishlist",
                          function: () {
                            Navigator.pushNamed(
                              context,
                              WishlistScreen.routName,
                            );
                          },
                        ),
                  CustomListTile(
                    imagePath: AssetsManager.recent,
                    text: "Viewed recently",
                    function: () {
                      Navigator.pushNamed(
                        context,
                        ViewedResentlyScreen.routName,
                      );
                    },
                  ),
                  CustomListTile(
                    imagePath: AssetsManager.address,
                    text: "Address",
                    function: () {},
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'Settings',
                    style: Styles.textStyle23,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SwitchListTile(
                    secondary: Image.asset(
                      AssetsManager.theme,
                      height: 30,
                    ),
                    title: Text(
                      themeProvider.getIsDarkTheme ? "Dark mode" : "Light mode",
                      style: Styles.textStyle18,
                    ),
                    value: themeProvider.getIsDarkTheme,
                    onChanged: (value) {
                      themeProvider.setDarkTheme(themeValue: value);
                    },
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  Center(
                    child: SizedBox(
                      width: 220,
                      height: 50, // Set the desired width here
                      child: DropdownButton<Language>(
                        borderRadius: BorderRadius.circular(30),
                        hint: const Text('Change Language'),
                        icon: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.language,
                            color: Colors.black,
                          ),
                        ),
                        onChanged: (Language? language) async {
                          if (language != null) {
                            Locale locale =
                                await setLocale(language.languageCode);
                            MyApp.setLocale(
                                context, Locale(language.languageCode, ''));
                          }
                        },
                        items: Language.languageList()
                            .map<DropdownMenuItem<Language>>(
                              (e) => DropdownMenuItem<Language>(
                                value: e,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          8.0), // Adjust the padding as needed
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text(
                                        e.flag,
                                        style: const TextStyle(fontSize: 30),
                                      ),
                                      Text(e.name)
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 240, 42, 28),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(160, 60), //! تعيين حجم الزر هنا
                ),
                onPressed: () async {
                  if (user == null) {
                    await Navigator.pushNamed(
                      context,
                      LoginScreen.routName,
                    );
                  } else {
                    await MyAppWornaing.showErrorORWarningDialog(
                        context: context,
                        subtitle: "Are you sure?",
                        fct: () async {
                          await FirebaseAuth.instance.signOut();
                          if (!mounted) return;
                          await Navigator.pushNamed(
                            context,
                            LoginScreen.routName,
                          );
                        },
                        isError: false);
                  }
                },
                icon: Icon(user == null ? Icons.login : Icons.logout),
                label: Text(
                  user == null ? "Login" : 'Logout',
                  style: Styles.textStyle18,
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
