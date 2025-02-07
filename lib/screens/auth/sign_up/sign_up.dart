import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectcs445/constants/constants.dart';
import 'package:projectcs445/constants/routes.dart';
import 'package:projectcs445/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:projectcs445/screens/auth/login/login.dart';
import 'package:projectcs445/screens/custom_bottom_bar/custom_bottom_bar.dart';
import 'package:projectcs445/widgets/primary_button/primary_button.dart';
import 'package:projectcs445/widgets/top_titles/top_titles.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isShowPass = true;

  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _name = new TextEditingController();
  TextEditingController _phone = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 50.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopTitles(
                title: "Đăng ký",
                subtitle: "Chào bạn đến với ứng dụng của tôi",
              ),
              const SizedBox(height: 45),
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                  hintText: "Tên của bạn",
                  prefixIcon: Icon(Icons.info),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "Email",
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: "Số điện thoại",
                  prefixIcon: Icon(Icons.phone),
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
                  bool isValidated = signUpValidation(
                      _email.text, _password.text, _name.text, _phone.text);
                  if (isValidated) {
                    bool isLogined = await FirebaseAuthHelper.instance.signUp(
                        _name.text, _email.text, _password.text, context);
                    if (isLogined) {
                      Routes.instance.pushAndRemoveUntil(
                        widget: const CustomBottomBar(),
                        context: context,
                      );
                    }
                  }
                },
                title: "Tạo tài khoản",
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Bạn đã có tài khoản?",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      Routes.instance.push(
                        widget: const Login(),
                        context: context,
                      );
                    },
                    child: const Text(
                      "Đăng nhập",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
