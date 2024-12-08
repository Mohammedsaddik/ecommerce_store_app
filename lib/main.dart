import 'package:ecommerce_store_app/Screens/Register_screen/register_screen.dart';
import 'package:ecommerce_store_app/Screens/forgot_password_screen/forgot_password.dart';
import 'package:ecommerce_store_app/Screens/inner_screens/viewed_resently.dart';
import 'package:ecommerce_store_app/Screens/inner_screens/wishlist.dart';
import 'package:ecommerce_store_app/Screens/login_screen/login_screen.dart';
import 'package:ecommerce_store_app/Screens/orders_screen/orders_screen.dart';
import 'package:ecommerce_store_app/Screens/root_screen/root_screen.dart';
import 'package:ecommerce_store_app/Screens/search_screen/search_screen.dart';
import 'package:ecommerce_store_app/Screens/search_screen/widget/product_details.dart';
import 'package:ecommerce_store_app/Screens/splash_screen/splash_screen.dart';
import 'package:ecommerce_store_app/Stripe_PayMent/Stripe_keys.dart';
import 'package:ecommerce_store_app/constant/theams.dart';
import 'package:ecommerce_store_app/firebase_options.dart';
import 'package:ecommerce_store_app/localication_classes/language_constants.dart';
import 'package:ecommerce_store_app/providers/cart_provider.dart';
import 'package:ecommerce_store_app/providers/order_provider.dart';
import 'package:ecommerce_store_app/providers/theam_provider.dart';
import 'package:ecommerce_store_app/providers/user_provider.dart';
import 'package:ecommerce_store_app/providers/viewed_prod_provider.dart';
import 'package:ecommerce_store_app/providers/wishlist_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';

void main() async {
  Stripe.publishableKey = ApiKeys.Publishablekey;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) => {setLocale(locale)});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => WishlistProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ViewedProdProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrdersProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Shop Smart AR',
            theme: StylesTheam.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme,
              context: context,
            ),
            locale: _locale,
            home: const SplashScreen(),
            routes: {
              ProductDetails.routName: (context) => const ProductDetails(),
              WishlistScreen.routName: (context) => const WishlistScreen(),
              ViewedResentlyScreen.routName: (context) =>
                  const ViewedResentlyScreen(),
              RegisterScreen.routName: (context) => const RegisterScreen(),
              LoginScreen.routName: (context) => const LoginScreen(),
              OrdersScreenFree.routeName: (context) => const OrdersScreenFree(),
              ForgotPasswordScreen.routeName: (context) =>
                  const ForgotPasswordScreen(),
              SearchScreen.routeName: (context) => const SearchScreen(),
              RootScreen.routName: (context) => const RootScreen(),
            },
          );
        },
      ),
    );
  }
}
