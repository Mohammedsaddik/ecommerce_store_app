import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:ecommerce_store_app/Screens/search_screen/widget/product_widget.dart';
import 'package:ecommerce_store_app/models/product_model.dart';
import 'package:ecommerce_store_app/providers/product_provider.dart';
import 'package:ecommerce_store_app/services/asset_manager.dart';
import 'package:ecommerce_store_app/widget/colors_text.dart';
import 'package:ecommerce_store_app/widget/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/searchScreen';

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchTextController;

  @override
  void initState() {
    searchTextController = TextEditingController();
    super.initState();
  }

  List<ProductModel> ProductListSearch = [];

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    String? passedCategory =
        ModalRoute.of(context)!.settings.arguments as String?;

    final List<ProductModel> productList = passedCategory == null
        ? productProvider.getProducts
        : productProvider.findByCategory(ctgName: passedCategory);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: ColorText(text: passedCategory ?? 'Store Product'),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(AssetsManager.shoppingCart),
            ),
          ),
          body: productList.isEmpty
              ? const Center(
                  child: TitlesTextWidget(label: "No product found"),
                )
              : StreamBuilder<List<ProductModel>>(
                  stream: productProvider.fetchProductsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: TitlesTextWidget(
                          label: snapshot.error.toString(),
                        ),
                      );
                    } else if (snapshot.data == null) {
                      return const Center(
                        child: TitlesTextWidget(
                          label: "No product has been added",
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: searchTextController,
                            decoration: InputDecoration(
                              fillColor: Colors.grey[200],
                              hintText: "Search",
                              filled: true,
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Icon(
                                  Icons.search,
                                  size: 30,
                                ),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  searchTextController.clear();
                                  FocusScope.of(context).unfocus();
                                },
                                child: const Icon(
                                  Icons.clear,
                                  color: Color.fromARGB(255, 255, 38, 23),
                                  size: 30,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 0, 15,
                                        27)), // Change the border color here
                              ),
                            ),
                            onChanged: (value) {},
                            onSubmitted: (value) {
                              setState(() {
                                ProductListSearch = productProvider.searchQuery(
                                    SearchText: searchTextController.text,
                                    PassedList: productList);
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          if (searchTextController.text.isNotEmpty &&
                              ProductListSearch.isEmpty) ...[
                            const Center(
                                child: TitlesTextWidget(
                              label: "No results found",
                              fontSize: 40,
                            ))
                          ],
                          Expanded(
                            child: DynamicHeightGridView(
                              physics: const BouncingScrollPhysics(),
                              itemCount: searchTextController.text.isNotEmpty
                                  ? ProductListSearch.length
                                  : productList.length,
                              builder: ((context, index) {
                                return ProductWidget(
                                  productId:
                                      searchTextController.text.isNotEmpty
                                          ? ProductListSearch[index].productId
                                          : productList[index].productId,
                                );
                              }),
                              crossAxisCount: 2,
                            ),
                          ),
                        ],
                      ),
                    );
                  })),
    );
  }
}
