import 'package:flutter/material.dart';
import 'package:projectcs445/constants/routes.dart';
import 'package:projectcs445/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:projectcs445/models/category_model/category_model.dart';
import 'package:projectcs445/models/product_model/product_model.dart';
import 'package:projectcs445/provider/app_provider.dart';
import 'package:projectcs445/screens/category_view/category_view.dart';
import 'package:projectcs445/screens/chatbot_screen/chatbot_screen.dart';
import 'package:projectcs445/screens/product_detail/product_details.dart';
import 'package:projectcs445/widgets/top_titles/top_titles.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categoriesList = [];
  List<ProductModel> productModelList = [];

  bool isLoading = false;

  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.getUserInfoFirebase();
    getCategoryList();
    super.initState();
  }

  void getCategoryList() async {
    setState(() {
      isLoading = true;
    });
    FirebaseFirestoreHelper.instance.updateTokenFromFirebase();
    categoriesList = await FirebaseFirestoreHelper.instance.getCategories();
    productModelList = await FirebaseFirestoreHelper.instance.getBestProducts();

    productModelList.shuffle();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  TextEditingController search = TextEditingController();
  List<ProductModel> searchList = [];
  void searchProducts(String value) {
    searchList = productModelList
        .where((element) =>
            element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50.0),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TopTitles(title: "My app", subtitle: ""),
                        TextFormField(
                          controller: search,
                          onChanged: (value) {
                            searchProducts(value);
                          },
                          decoration:
                              const InputDecoration(hintText: "Search..."),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Danh mục",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  categoriesList.isEmpty
                      ? const Center(
                          child: Text("Trống"),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: categoriesList
                                .map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Routes.instance.push(
                                            widget:
                                                CategoryView(categoryModel: e),
                                            context: context);
                                      },
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 7,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: Image.network(e.image),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                  const SizedBox(height: 12),
                  !isSearched()
                      ? const Padding(
                          padding: EdgeInsets.only(top: 12, left: 12),
                          child: Text(
                            "Sản phẩm nổi bật",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : SizedBox.fromSize(),
                  search.text.isNotEmpty && searchList.isEmpty
                      ? const Center(
                          child: Text("Không tìm thấy sản phẩm"),
                        )
                      : searchList.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(12),
                              child: GridView.builder(
                                padding: const EdgeInsets.only(bottom: 50),
                                shrinkWrap: true,
                                primary: false,
                                itemCount: searchList.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 20,
                                  crossAxisSpacing: 20,
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.8,
                                ),
                                itemBuilder: (ctx, index) {
                                  ProductModel singleProduct =
                                      searchList[index];
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        Routes.instance.push(
                                          widget: ProductDetails(
                                            singleProduct: singleProduct,
                                          ),
                                          context: context,
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.network(
                                            singleProduct.image!,
                                            height: 100,
                                            width: 100,
                                          ),
                                          const SizedBox(height: 12.0),
                                          Text(
                                            singleProduct.name,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                              "Price: \$${singleProduct.price}"),
                                          const SizedBox(height: 12.0),
                                          SizedBox(
                                            height: 45,
                                            width: 140,
                                            child: OutlinedButton(
                                              onPressed: () {
                                                Routes.instance.push(
                                                  widget: ProductDetails(
                                                    singleProduct:
                                                        singleProduct,
                                                  ),
                                                  context: context,
                                                );
                                              },
                                              child: const Text(
                                                "Buy",
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : productModelList.isEmpty
                              ? const Center(
                                  child: Text("Không có sản phẩm nổi bật"),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: GridView.builder(
                                    padding: const EdgeInsets.only(bottom: 50),
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: productModelList.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: 20,
                                      crossAxisSpacing: 20,
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.8,
                                    ),
                                    itemBuilder: (ctx, index) {
                                      ProductModel singleProduct =
                                          productModelList[index];
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            Routes.instance.push(
                                              widget: ProductDetails(
                                                singleProduct: singleProduct,
                                              ),
                                              context: context,
                                            );
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.network(
                                                singleProduct.image!,
                                                height: 100,
                                                width: 100,
                                              ),
                                              const SizedBox(height: 12.0),
                                              Text(
                                                singleProduct.name,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                  "Price: \$${singleProduct.price}"),
                                              const SizedBox(height: 12.0),
                                              SizedBox(
                                                height: 45,
                                                width: 140,
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    Routes.instance.push(
                                                      widget: ProductDetails(
                                                        singleProduct:
                                                            singleProduct,
                                                      ),
                                                      context: context,
                                                    );
                                                  },
                                                  child: const Text(
                                                    "Buy",
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
    );
  }

  bool isSearched() {
    if (search.text.isNotEmpty && searchList.isEmpty) {
      return true;
    } else if (search.text.isEmpty && searchList.isNotEmpty) {
      return false;
    } else if (searchList.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
