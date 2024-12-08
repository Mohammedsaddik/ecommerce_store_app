import 'dart:developer';

import 'package:ecommerce_store_app/Screens/cart_screen/widget/Quantity_Bottom_Sheet.dart';
import 'package:ecommerce_store_app/Screens/home_screen/widget/heart_btn.dart';
import 'package:ecommerce_store_app/constant/styls.dart';
import 'package:ecommerce_store_app/models/cart_model.dart';
import 'package:ecommerce_store_app/providers/cart_provider.dart';
import 'package:ecommerce_store_app/providers/product_provider.dart';
import 'package:ecommerce_store_app/widget/subtitle_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final CartModelProvider = Provider.of<CartModel>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final getCurrProduct =
        productProvider.findByProdId(CartModelProvider.productId);
    Size size = MediaQuery.of(context).size;
    return getCurrProduct == null
        ? const SizedBox.shrink()
        : FittedBox(
            child: IntrinsicWidth(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FancyShimmerImage(
                        imageUrl: getCurrProduct.productImage,
                        height: 150,
                        width: 150,
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    IntrinsicWidth(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                  width: size.width * 0.6,
                                  child: Text(
                                    getCurrProduct.productTitle,
                                    maxLines: 2,
                                    style: Styles.textStyle20,
                                  )),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      try {
                                        await cartProvider
                                            .removeCartItemFromFirebase(
                                          cartId: CartModelProvider.cartId,
                                          productId: getCurrProduct.productId,
                                          qty: CartModelProvider.quantity,
                                        );
                                      } catch (error) {
                                        log(error.toString());
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.red,
                                      size: 30.0,
                                    ),
                                  ),
                                  HeartButtonWidget(
                                    size: 30.0,
                                    productId: getCurrProduct.productId,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SubtitleTextWidget(
                                label: "${getCurrProduct.productPrice}\$",
                                fontSize: 23,
                                color: Colors.blueAccent,
                              ),
                              const SizedBox(
                                width: 100.0,
                              ),
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28)),
                                  side: const BorderSide(
                                    width: 2,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                onPressed: () async {
                                  await showModalBottomSheet(
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(70.0),
                                        topRight: Radius.circular(70.0),
                                      ),
                                    ),
                                    context: context,
                                    builder: (context) {
                                      return QuantityBottomSheetWidget(
                                        cartModel: CartModelProvider,
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(IconlyLight.arrow_down_2),
                                label:
                                    Text("Qty: ${CartModelProvider.quantity} "),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
