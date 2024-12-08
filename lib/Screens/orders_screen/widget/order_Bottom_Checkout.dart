import 'package:ecommerce_store_app/Stripe_PayMent/payment_manager.dart';
import 'package:ecommerce_store_app/providers/order_provider.dart';
import 'package:ecommerce_store_app/providers/product_provider.dart';
import 'package:ecommerce_store_app/widget/subtitle_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderBottomCheckout extends StatelessWidget {
  final Function function;
  const OrderBottomCheckout({super.key, required this.function});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrdersProvider>(context);
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
                    const SizedBox(
                      height: 15,
                    ),
                    SubtitleTextWidget(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      label:
                          "${orderProvider.getTotalPrice(productProvider: productProvider)}\$",
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
                  minimumSize: const Size(70, 60), // تعيين حجم الزر هنا
                ),
                onPressed: () => PaymentManager.makePayment(
                    orderProvider
                        .getTotalPrice(productProvider: productProvider)
                        .toInt(),
                    "EGP"),
                child: const Text(
                  "To Pay",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
