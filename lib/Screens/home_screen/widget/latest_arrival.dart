import 'package:ecommerce_store_app/Screens/home_screen/widget/heart_btn.dart';
import 'package:ecommerce_store_app/Screens/search_screen/widget/product_details.dart';
import 'package:ecommerce_store_app/models/product_model.dart';
import 'package:ecommerce_store_app/providers/cart_provider.dart';
import 'package:ecommerce_store_app/providers/viewed_prod_provider.dart';
import 'package:ecommerce_store_app/widget/my_app_method.dart';
import 'package:ecommerce_store_app/widget/subtitle_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LatestArrival extends StatelessWidget {
  const LatestArrival({super.key});

  @override
  Widget build(BuildContext context) {
    final productsModel = Provider.of<ProductModel>(context);
    final viewedProvider = Provider.of<ViewedProdProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          viewedProvider.addProductToHistory(
              productId: productsModel.productId);
          await Navigator.pushNamed(
            context,
            ProductDetails.routName,
            arguments: productsModel.productId,
          );
        },
        child: SizedBox(
          width: size.width * 0.60,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FancyShimmerImage(
                    imageUrl: productsModel.productImage,
                    width: 120,
                    height: 120,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productsModel.productTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Center(
                      child: FittedBox(
                        child: Row(
                          children: [
                            HeartButtonWidget(
                                size: 24, productId: productsModel.productId),
                            const SizedBox(
                              width: 15,
                            ),
                            IconButton(
                              onPressed: () async {
                                if (cartProvider.isProductInCart(
                                    productId: productsModel.productId)) {
                                  return;
                                }
                                try {
                                  await cartProvider.addToCartFirebase(
                                      productId: productsModel.productId,
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
                                        productId: productsModel.productId)
                                    ? Icons.check_sharp
                                    : Icons.add_shopping_cart_rounded,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: FittedBox(
                        child: SubtitleTextWidget(
                          label: "${productsModel.productPrice}\$",
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
