import 'package:ecommerce_store_app/constant/styls.dart';
import 'package:ecommerce_store_app/providers/cart_provider.dart';
import 'package:ecommerce_store_app/providers/product_provider.dart';
import 'package:ecommerce_store_app/widget/subtitle_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartBottomCheckout extends StatelessWidget {
  final Function function;
  const CartBottomCheckout({super.key, required this.function});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: const Border(
          top: BorderSide(width: 1, color: Colors.grey),
        ),
      ),
      child: SizedBox(
        height: kBottomNavigationBarHeight + 15,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                        child: Text(
                      'Total (${cartProvider.getCartItems.length} products/${cartProvider.getQty()} Items)',
                      style: Styles.textStyle15,
                    )),
                    const SizedBox(
                      height: 7,
                    ),
                    SubtitleTextWidget(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      label:
                          "${cartProvider.getTotal(productProvider: productProvider)}\$",
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(50, 40), // تعيين حجم الزر هنا
                ),
                onPressed: () async {
                  await function();
                },
                child: const Text("Checkout"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
