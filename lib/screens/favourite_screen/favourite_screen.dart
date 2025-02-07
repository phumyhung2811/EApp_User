import 'package:flutter/material.dart';
import 'package:projectcs445/provider/app_provider.dart';
import 'package:projectcs445/screens/favourite_screen/widgets/single_favourite_item.dart';
import 'package:provider/provider.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sản phẩm yêu thích",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: appProvider.getFavouriteProductList.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (ctx, item) {
          return SingleFavouriteItem(
            singleProduct: appProvider.getFavouriteProductList[item],
          );
        },
      ),
    );
  }
}
