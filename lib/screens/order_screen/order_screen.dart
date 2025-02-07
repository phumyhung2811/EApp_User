import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectcs445/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:projectcs445/models/order_model/order_model.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Đơn hàng của bạn",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestoreHelper.instance.getUserOrder(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.isEmpty ||
              snapshot.data == null ||
              !snapshot.hasData) {
            return const Center(
              child: Text("Không có đơn hàng"),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 70),
            itemBuilder: (context, index) {
              OrderModel orderModel = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  collapsedShape: const RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.black,
                      width: 2.3,
                    ),
                  ),
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.black,
                      width: 2.3,
                    ),
                  ),
                  title: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            color: Colors.grey.withOpacity(0.5),
                            child: Image.network(orderModel.products[0].image!),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  orderModel.products[0].name,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                orderModel.products.length > 1
                                    ? Column(
                                        children: [
                                          Text(
                                            "Số lượng: ${orderModel.products[0].sluong.toString()}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                        ],
                                      )
                                    : SizedBox.fromSize(),
                                Text(
                                  "Tổng tiền: \$${orderModel.totalPrice.toString()}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Trạng thái: ${orderModel.status}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                orderModel.status == "Đang xử lý"
                                    ? ElevatedButton(
                                        onPressed: () async {
                                          await FirebaseFirestoreHelper.instance
                                              .updateOrder(orderModel, "Hủy");
                                          orderModel.status = "Hủy";
                                          setState(() {});
                                        },
                                        child: const Text(
                                          "Hủy đơn hàng",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : SizedBox.fromSize(),
                                orderModel.status == "Đang vận chuyển" ||
                                        orderModel.status == "Đang xử lý"
                                    ? ElevatedButton(
                                        onPressed: () {
                                          FirebaseFirestoreHelper.instance
                                              .updateOrder(
                                                  orderModel, "Xác nhận");
                                          orderModel.status = "Xác nhận";
                                          setState(() {});
                                        },
                                        child: const Text(
                                          "Đơn đã giao",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : SizedBox.fromSize(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  children: orderModel.products.length > 1
                      ? [
                          const Text("Chi tiết"),
                          const Divider(color: Colors.red),
                          ...orderModel.products.map((singleProduct) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 12.0, top: 6),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 80,
                                        width: 80,
                                        color: Colors.red.withOpacity(0.5),
                                        child:
                                            Image.network(singleProduct.image!),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          height: 140,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  singleProduct.name,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      "Số lượng: ${singleProduct.sluong.toString()}",
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),
                                                  ],
                                                ),
                                                Text(
                                                  "Tổng tiền: \$${singleProduct.price.toString()}",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(color: Colors.red),
                                ],
                              ),
                            );
                          }).toList()
                        ]
                      : [],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
