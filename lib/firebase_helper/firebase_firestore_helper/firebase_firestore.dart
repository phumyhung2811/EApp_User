import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:projectcs445/constants/constants.dart';
import 'package:projectcs445/models/category_model/category_model.dart';
import 'package:projectcs445/models/order_model/order_model.dart';
import 'package:projectcs445/models/product_model/product_model.dart';
import 'package:projectcs445/models/user_model/user_model.dart';

class FirebaseFirestoreHelper {
  static FirebaseFirestoreHelper instance = FirebaseFirestoreHelper();

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<CategoryModel>> getCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collection("categories").get();

      List<CategoryModel> categoriesList = querySnapshot.docs
          .map((e) => CategoryModel.fromJson(e.data()))
          .toList();

      return categoriesList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> getBestProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collectionGroup("products").get();

      List<ProductModel> productModelList = querySnapshot.docs
          .map((e) => ProductModel.fromJson(e.data()))
          .toList();

      return productModelList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> getCategoryViewProduct(String id) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection("categories")
              .doc(id)
              .collection("products")
              .get();

      List<ProductModel> productModelList = querySnapshot.docs
          .map((e) => ProductModel.fromJson(e.data()))
          .toList();

      return productModelList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<UserModel> getUserInformation() async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestore
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

    return UserModel.fromJson(querySnapshot.data()!);
  }

  Future<bool> uploadOrderedProductFirebase(
    List<ProductModel> list,
    BuildContext context,
    String payment,
  ) async {
    try {
      showLoaderDialog(context);
      double totalPrice = 0.0;
      for (var element in list) {
        totalPrice += element.price * element.sluong!;
      }

      DocumentReference documentReference = _firebaseFirestore
          .collection("usersOrders")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("orders")
          .doc();

      DocumentReference admin =
          _firebaseFirestore.collection("orders").doc(documentReference.id);

      String uid = FirebaseAuth.instance.currentUser!.uid;

      admin.set({
        "products": list.map((e) => e.toJson()),
        "status": "Đang xử lý",
        "totalPrice": totalPrice,
        "payment": payment,
        "userId": uid,
        "orderId": admin.id,
      });

      documentReference.set({
        "products": list.map((e) => e.toJson()),
        "status": "Đang xử lý",
        "totalPrice": totalPrice,
        "payment": payment,
        "userId": uid,
        "orderId": documentReference.id,
      });
      Navigator.of(context, rootNavigator: true).pop();
      showMessage("Thanh toán thành công");
      return true;
    } catch (e) {
      showMessage(e.toString());
      Navigator.of(context, rootNavigator: true).pop();

      return false;
    }
  }

  // Xem đơn hàng
  Future<List<OrderModel>> getUserOrder() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection("usersOrders")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("orders")
              .get();

      List<OrderModel> orderList =
          querySnapshot.docs.map((e) => OrderModel.fromJson(e.data())).toList();

      return orderList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  void updateTokenFromFirebase() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await _firebaseFirestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(
        {
          "notificationToken": token,
        },
      );
    }
  }

  Future<void> updateOrder(OrderModel orderModel, String status) async {
    await _firebaseFirestore
        .collection("usersOrders")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("orders")
        .doc(orderModel.orderId)
        .update(
      {
        "status": status,
      },
    );

    await _firebaseFirestore
        .collection("orders")
        .doc(orderModel.orderId)
        .update(
      {
        "status": status,
      },
    );
  }
}
