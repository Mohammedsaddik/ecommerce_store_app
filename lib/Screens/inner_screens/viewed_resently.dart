import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:ecommerce_store_app/Screens/search_screen/widget/product_widget.dart';
import 'package:ecommerce_store_app/providers/viewed_prod_provider.dart';
import 'package:ecommerce_store_app/services/asset_manager.dart';
import 'package:ecommerce_store_app/widget/colors_text.dart';
import 'package:ecommerce_store_app/widget/empty_bag.dart';
import 'package:ecommerce_store_app/widget/my_app_method.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewedResentlyScreen extends StatelessWidget {
  static const routName = '/ViewedResentlyScreen';
  const ViewedResentlyScreen({super.key});
  final bool isEmpty = false;
  @override
  Widget build(BuildContext context) {
    final viewedProvider = Provider.of<ViewedProdProvider>(context);
    return viewedProvider.getviewedProdItems.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: AssetsManager.bagWish,
              title: "Your viewed recently \nis empty",
              subtitle:
                  'Looks like you didn\'t add anything yet to your cart \ngo ahead and start shopping now',
              buttonText: "Shop Now",
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: ColorText(
                  text:
                      'Viewed recently (${viewedProvider.getviewedProdItems.length})'),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(AssetsManager.shoppingCart),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                  child: IconButton(
                    onPressed: () {
                      MyAppWornaing.showErrorORWarningDialog(
                          context: context,
                          subtitle: 'Remove Title',
                          fct: () {
                            viewedProvider.clearLocalViewed();
                          });
                    },
                    icon: const Icon(
                      Icons.delete_forever_rounded,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  ),
                ),
              ],
            ),
            body: DynamicHeightGridView(
              physics: const BouncingScrollPhysics(),
              itemCount: viewedProvider.getviewedProdItems.length,
              builder: ((context, index) {
                return ProductWidget(
                  productId: viewedProvider.getviewedProdItems.values
                      .toList()[index]
                      .productId,
                );
              }),
              crossAxisCount: 2,
            ),
          );
  }
}
