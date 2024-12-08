import 'dart:developer';

import 'package:ecommerce_store_app/Screens/cart_screen/cart_screen.dart';
import 'package:ecommerce_store_app/Screens/home_screen/home_screen.dart';
import 'package:ecommerce_store_app/Screens/profile_screen/profile_screen.dart';
import 'package:ecommerce_store_app/Screens/search_screen/search_screen.dart';
import 'package:ecommerce_store_app/providers/cart_provider.dart';
import 'package:ecommerce_store_app/providers/product_provider.dart';
import 'package:ecommerce_store_app/providers/user_provider.dart';
import 'package:ecommerce_store_app/providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class RootScreen extends StatefulWidget {
  static const routName = '/RootScreen';
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late PageController controller;
  int CurrentScreen = 0;
  List<Widget> screens = [
    const HomeScreen(),
    const SearchScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];
  bool isLoadingProds = true;
  @override
  void initState() {
    controller = PageController(initialPage: CurrentScreen);
    super.initState();
  }

  Future<void> fetchFCT() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final productsProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final wishlistProvider =
        Provider.of<WishlistProvider>(context, listen: false);
    try {
      Future.wait({
        productsProvider.fetchProducts(),
        userProvider.fetchUserInfo(),
      });
      Future.wait({
        cartProvider.fetchCart(),
        wishlistProvider.fetchWishlist(),
      });
    } catch (error) {
      log(error.toString());
    } finally {
      setState(() {
        isLoadingProds = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    if (isLoadingProds) {
      fetchFCT();
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 2,
        height: kBottomNavigationBarHeight,
        selectedIndex: CurrentScreen,
        onDestinationSelected: (index) {
          setState(() {
            CurrentScreen = index;
          });
          controller.jumpToPage(CurrentScreen);
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(IconlyLight.home),
            label: 'Home',
            selectedIcon: Icon(IconlyBold.home),
          ),
          const NavigationDestination(
            icon: Icon(IconlyLight.search),
            label: 'Search',
            selectedIcon: Icon(IconlyBold.search),
          ),
          NavigationDestination(
            icon: Badge(
                label: Text(cartProvider.getCartItems.length.toString()),
                child: const Icon(IconlyLight.bag_2)),
            label: 'Cart',
            selectedIcon: const Icon(IconlyBold.bag_2),
          ),
          const NavigationDestination(
            icon: Icon(IconlyLight.profile),
            label: 'Profile',
            selectedIcon: Icon(IconlyBold.profile),
          ),
        ],
      ),
    );
  }
}
