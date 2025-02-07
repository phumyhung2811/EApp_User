import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectcs445/constants/asset_image.dart';
import 'package:projectcs445/constants/routes.dart';
import 'package:projectcs445/screens/auth/login/login.dart';
import 'package:projectcs445/screens/auth/sign_up/sign_up.dart';
import 'package:projectcs445/widgets/primary_button/primary_button.dart';
import 'package:projectcs445/widgets/top_titles/top_titles.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopTitles(
                title: "Welcome",
                subtitle: "Mua những sản phẩm từ ứng dụng",
              ),
              Center(
                child: Image.asset(AssetsImages.instance.welcomeImage),
              ),
              const SizedBox(height: 170.0),
              PrimaryButton(
                title: "Đăng nhập",
                onPressed: () {
                  Routes.instance.push(
                    widget: const Login(),
                    context: context,
                  );
                },
              ),
              const SizedBox(height: 18.0),
              PrimaryButton(
                title: "Đăng ký",
                onPressed: () {
                  Routes.instance.push(
                    widget: const SignUp(),
                    context: context,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
