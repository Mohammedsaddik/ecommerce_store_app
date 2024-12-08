import 'package:ecommerce_store_app/providers/wishlist_provider.dart';
import 'package:ecommerce_store_app/widget/my_app_method.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class HeartButtonWidget extends StatefulWidget {
  const HeartButtonWidget({
    super.key,
    this.size = 22,
    this.color = Colors.transparent,
    required this.productId,
  });
  final double size;
  final Color color;
  final String productId;
  @override
  State<HeartButtonWidget> createState() => _HeartButtonWidgetState();
}

class _HeartButtonWidgetState extends State<HeartButtonWidget> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.color,
      ),
      child: IconButton(
        style: IconButton.styleFrom(
          shape: const CircleBorder(),
        ),
        onPressed: () async {
          //wishlistProvider.addOrRemoveFromWishlist(productId: widget.productId);
          setState(() {
            isLoading = true;
          });
          try {
            if (wishlistProvider.getWishlistItems
                .containsKey(widget.productId)) {
              wishlistProvider.removeWishlistItemFromFirebase(
                wishlistId:
                    wishlistProvider.getWishlistItems[widget.productId]!.id,
                productId: widget.productId,
              );
            } else {
              wishlistProvider.addToWishlistFirebase(
                  productId: widget.productId, context: context);
            }
            await wishlistProvider.fetchWishlist();
          } catch (e) {
            MyAppWornaing.showErrorORWarningDialog(
              context: context,
              subtitle: e.toString(),
              fct: () {},
            );
          } finally {
            setState(() {
              isLoading = false;
            });
          }
        },
        icon: isLoading
            ? SizedBox(
                width: widget.size,
                height: widget.size,
                child: const CircularProgressIndicator(
                  strokeWidth: 0.01, // سمك الدائرة
                ),
              )
            : Icon(
                wishlistProvider.isProductInWishlist(
                        productId: widget.productId)
                    ? IconlyBold.heart
                    : IconlyLight.heart,
                size: widget.size,
                color: wishlistProvider.isProductInWishlist(
                        productId: widget.productId)
                    ? Colors.red
                    : Colors.grey,
              ),
      ),
    );
  }
}
