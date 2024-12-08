import 'package:ecommerce_store_app/Screens/home_screen/widget/heart_btn.dart';
import 'package:ecommerce_store_app/Screens/search_screen/widget/product_details.dart';
import 'package:ecommerce_store_app/providers/cart_provider.dart';
import 'package:ecommerce_store_app/providers/product_provider.dart';
import 'package:ecommerce_store_app/providers/viewed_prod_provider.dart';
import 'package:ecommerce_store_app/widget/my_app_method.dart';
import 'package:ecommerce_store_app/widget/subtitle_text.dart';
import 'package:ecommerce_store_app/widget/title_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatefulWidget {
  final String productId;
  const ProductWidget({super.key, required this.productId});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrProduct = productProvider.findByProdId(widget.productId);
    final viewedProvider = Provider.of<ViewedProdProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    Size size = MediaQuery.of(context).size;
    return getCurrProduct == null
        ? const SizedBox.square()
        : Padding(
            padding: const EdgeInsets.only(right: 10.0, left: 10.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(15.0),
              onTap: () async {
                viewedProvider.addProductToHistory(
                    productId: getCurrProduct.productId);
                await Navigator.pushNamed(
                  context,
                  ProductDetails.routName,
                  arguments: getCurrProduct.productId,
                );
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Material(
                      elevation: 8, // Adjust the elevation value as needed
                      borderRadius: BorderRadius.circular(15.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: FancyShimmerImage(
                          imageUrl: getCurrProduct.productImage,
                          width: double.infinity,
                          height: size.height * 0.22,
                          boxFit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 5,
                            child: TitlesTextWidget(
                              label: getCurrProduct.productTitle,
                              fontSize: 16,
                              maxLines: 2,
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: HeartButtonWidget(
                                size: 25.0,
                                productId: getCurrProduct.productId),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 3,
                            child: SubtitleTextWidget(
                              label: "${getCurrProduct.productPrice}\$",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          Flexible(
                            child: Material(
                              borderRadius: BorderRadius.circular(16.0),
                              color: Colors.lightBlue,
                              child: InkWell(
                                splashColor: Colors.red,
                                borderRadius: BorderRadius.circular(16.0),
                                onTap: () async {
                                  if (cartProvider.isProductInCart(
                                      productId: getCurrProduct.productId)) {
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
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(
                                    cartProvider.isProductInCart(
                                            productId: getCurrProduct.productId)
                                        ? Icons.check
                                        : Icons.add_shopping_cart_rounded,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
