import 'package:ecommerce_store_app/Screens/home_screen/widget/heart_btn.dart';
import 'package:ecommerce_store_app/providers/cart_provider.dart';
import 'package:ecommerce_store_app/providers/product_provider.dart';
import 'package:ecommerce_store_app/widget/colors_text.dart';
import 'package:ecommerce_store_app/widget/my_app_method.dart';
import 'package:ecommerce_store_app/widget/subtitle_text.dart';
import 'package:ecommerce_store_app/widget/title_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  static const routName = '/ProductDetails';
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final getCurrProduct = productProvider.findByProdId(productId);
    final cartProvider = Provider.of<CartProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const ColorText(text: 'ShopSmart'),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 24,
              )),
        ),
        // automaticallyImplyLeading: false,
      ),
      body: getCurrProduct == null
          ? const SizedBox.shrink()
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  FancyShimmerImage(
                    imageUrl: getCurrProduct.productImage,
                    height: size.height * 0.38,
                    width: double.infinity,
                    boxFit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                  // flex: 5,
                                  child: Text(
                                getCurrProduct.productTitle,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines:
                                    2, // Set the maximum number of lines here
                                overflow: TextOverflow
                                    .ellipsis, // Add ellipsis (...) if the text overflows
                              )),
                              const SizedBox(
                                width: 14,
                              ),
                              SubtitleTextWidget(
                                label: "${getCurrProduct.productPrice}\$",
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              HeartButtonWidget(
                                color: Colors.blue.shade300,
                                productId: getCurrProduct.productId,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: kBottomNavigationBarHeight - 10,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.lightBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (cartProvider.isProductInCart(
                                          productId:
                                              getCurrProduct.productId)) {
                                        return;
                                      }
                                      try {
                                        await cartProvider.addToCartFirebase(
                                            productId: getCurrProduct.productId,
                                            qty: 1,
                                            context: context);
                                      } catch (error) {
                                        MyAppWornaing.showErrorORWarningDialog(
                                            context: context,
                                            subtitle: error.toString(),
                                            fct: () {});
                                      }
                                    },
                                    icon: Icon(
                                      cartProvider.isProductInCart(
                                              productId:
                                                  getCurrProduct.productId)
                                          ? Icons.check
                                          : Icons.add_shopping_cart_rounded,
                                    ),
                                    label: Text(
                                      cartProvider.isProductInCart(
                                              productId:
                                                  getCurrProduct.productId)
                                          ? "In cart"
                                          : "Add to cart",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TitlesTextWidget(label: "About this item"),
                              SubtitleTextWidget(
                                  label: "In ${getCurrProduct.productCategory}")
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: SubtitleTextWidget(
                              label: getCurrProduct.productDescription),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
