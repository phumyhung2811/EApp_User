import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectcs445/constants/constants.dart';
import 'package:projectcs445/constants/routes.dart';
import 'package:projectcs445/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:projectcs445/screens/auth/sign_up/sign_up.dart';
import 'package:projectcs445/screens/custom_bottom_bar/custom_bottom_bar.dart';
import 'package:projectcs445/widgets/primary_button/primary_button.dart';
import 'package:projectcs445/widgets/top_titles/top_titles.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isShowPass = true;

  // Email, Password
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 50.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopTitles(
              title: "Đăng nhập",
              subtitle: "Chào bạn đến với ứng dụng của tôi",
            ),
            const SizedBox(height: 45),
            TextFormField(
              controller: _email,
              decoration: const InputDecoration(
                hintText: "Email",
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _password,
              obscureText: isShowPass,
              decoration: InputDecoration(
                hintText: "Password",
                prefixIcon: const Icon(Icons.password),
                suffixIcon: CupertinoButton(
                  onPressed: () {
                    setState(() {
                      isShowPass = !isShowPass;
                    });
                  },
                  child: const Icon(Icons.visibility),
                ),
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              onPressed: () async {
                bool isValidated = loginValidation(_email.text, _password.text);
                if (isValidated) {
                  bool isLogined = await FirebaseAuthHelper.instance
                      .login(_email.text, _password.text, context);
                  if (isLogined) {
                    Routes.instance.pushAndRemoveUntil(
                      widget: const CustomBottomBar(),
                      context: context,
                    );
                  }
                }
              },
              title: "Đăng nhập",
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Bạn chưa có tài khoản?",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                CupertinoButton(
                  onPressed: () {
                    Routes.instance.push(
                      widget: const SignUp(),
                      context: context,
                    );
                  },
                  child: const Text(
                    "Đăng ký",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
