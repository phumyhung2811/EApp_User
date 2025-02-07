import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectcs445/constants/constants.dart';
import 'package:projectcs445/constants/routes.dart';
import 'package:projectcs445/provider/app_provider.dart';
import 'package:projectcs445/screens/buy_product/checkout.dart';
import 'package:projectcs445/screens/cart_item_checkout/cart_item_checkout.dart';
import 'package:projectcs445/screens/cart_screen/widgets/single_cart_item.dart';
import 'package:projectcs445/widgets/primary_button/primary_button.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 180,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Tổng tiền",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "\$${appProvider.totalPrice().toString()}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                title: "Thanh toán",
                onPressed: () {
                  appProvider.clearBuyProduct();
                  appProvider.addBuyProductCartList();
                  appProvider.clearCart();
                  if (appProvider.getBuyProductList.isEmpty) {
                    showMessage("Giỏ hàng rỗng");
                  } else {
                    Routes.instance.push(
                        widget: const CartItemCheckout(), context: context);
                  }
                },
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text(
          "Giỏ hàng",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: appProvider.getCartProductList.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (ctx, item) {
          return SingleCartItem(
            singleProduct: appProvider.getCartProductList[item],
          );
        },
      ),
    );
  }
}
