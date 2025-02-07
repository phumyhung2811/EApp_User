import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:projectcs445/constants/routes.dart';
import 'package:projectcs445/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:projectcs445/provider/app_provider.dart';
import 'package:projectcs445/screens/custom_bottom_bar/custom_bottom_bar.dart';
import 'package:provider/provider.dart';

class StripeHelper {
  static StripeHelper instance = StripeHelper();

  Map<String, dynamic>? paymentIntent;
  Future<void> makePayment(String amount, BuildContext context) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'USD');

      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent?['client_secret'],
              style: ThemeMode.dark,
              merchantDisplayName: "MH",
            ),
          )
          .then((value) {});

      displayPaymentSheet(context);
    } catch (e) {
      print(e);
    }
  }
}

displayPaymentSheet(BuildContext context) async {
  AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
  try {
    await Stripe.instance.presentPaymentSheet().then((value) async {
      bool value =
          await FirebaseFirestoreHelper.instance.uploadOrderedProductFirebase(
        appProvider.getBuyProductList,
        context,
        "Chuyển khoản",
      );

      appProvider.clearBuyProduct();
      if (value) {
        Future.delayed(const Duration(seconds: 2), () {
          Routes.instance
              .push(widget: const CustomBottomBar(), context: context);
        });
      }
    });
  } catch (e) {
    print('$e');
  }
}

createPaymentIntent(String amount, String currency) async {
  try {
    Map<String, dynamic> body = {
      'amount': amount,
      'currency': currency,
    };

    var response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {
        'Authorization':
            'Bearer sk_test_51QLqOfK8ny5qNzn7gp9434BYf2RmlxgUjtQbu0L46G7kbPlSzq3w74Qn8V4emdgcXUSJjT7TAcamnrVUy2lvEGJx00ipUhjr8Y',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );
    return jsonDecode(response.body);
  } catch (e) {
    throw Exception(e.toString());
  }
}
