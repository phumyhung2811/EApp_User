import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectcs445/constants/constants.dart';
import 'package:projectcs445/constants/routes.dart';
import 'package:projectcs445/models/product_model/product_model.dart';
import 'package:projectcs445/provider/app_provider.dart';
import 'package:projectcs445/screens/cart_item_checkout/cart_item_checkout.dart';
import 'package:projectcs445/screens/cart_screen/cart_screen.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({
    super.key,
    required this.singleProduct,
  });

  final ProductModel singleProduct;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int sluong = 1;
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Routes.instance.push(
                widget: const CartScreen(),
                context: context,
              );
            },
            icon: const Icon(Icons.shopping_cart),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(widget.singleProduct.image!),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.singleProduct.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.singleProduct.isFavorite =
                            !widget.singleProduct.isFavorite;
                      });
                      if (widget.singleProduct.isFavorite) {
                        appProvider.addFavouriteProduct(widget.singleProduct);
                      } else {
                        appProvider
                            .removeFavouriteProduct(widget.singleProduct);
                      }
                    },
                    icon: Icon(
                      appProvider.getFavouriteProductList
                              .contains(widget.singleProduct)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
              Text(widget.singleProduct.description),
              const SizedBox(height: 20),
              Row(
                children: [
                  CupertinoButton(
                    onPressed: () {
                      if (sluong > 1) {
                        setState(() {
                          sluong--;
                        });
                      }
                    },
                    padding: EdgeInsets.zero,
                    child: const CircleAvatar(
                      backgroundColor: Colors.black26,
                      child: Icon(Icons.remove),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    sluong.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  CupertinoButton(
                    onPressed: () {
                      setState(() {
                        sluong++;
                      });
                    },
                    padding: EdgeInsets.zero,
                    child: const CircleAvatar(
                      backgroundColor: Colors.black26,
                      child: Icon(Icons.add),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      ProductModel productModel =
                          widget.singleProduct.copyWith(sluong: sluong);
                      appProvider.addCartProduct(productModel);
                      showMessage("Đã thêm vào giỏ hàng");
                    },
                    child: const Text(
                      "Thêm giỏ hàng",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 42,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        // ProductModel productModel =
                        //     widget.singleProduct.copyWith(sluong: sluong);
                        appProvider.clearBuyProduct();
                        appProvider.addBuyProductCartList();
                        appProvider.clearCart();
                        Routes.instance.push(
                          widget: const CartItemCheckout(),
                          context: context,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: const Text(
                        "Đặt hàng",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
