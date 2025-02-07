import 'package:flutter/material.dart';
import 'package:projectcs445/constants/routes.dart';
import 'package:projectcs445/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:projectcs445/provider/app_provider.dart';
import 'package:projectcs445/screens/change_password/change_password.dart';
import 'package:projectcs445/screens/edit_profile/edit_profile.dart';
import 'package:projectcs445/screens/favourite_screen/favourite_screen.dart';
import 'package:projectcs445/screens/order_screen/order_screen.dart';
import 'package:projectcs445/widgets/primary_button/primary_button.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Tài khoản",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                appProvider.getUserInformation.image == null
                    ? const Icon(
                        Icons.person_outline,
                        size: 120,
                      )
                    : CircleAvatar(
                        radius: 70,
                        backgroundImage:
                            NetworkImage(appProvider.getUserInformation.image!),
                      ),
                Text(
                  appProvider.getUserInformation.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(appProvider.getUserInformation.email),
                const SizedBox(height: 12),
                SizedBox(
                  width: 160,
                  child: PrimaryButton(
                    title: "Sửa thông tin",
                    onPressed: () {
                      Routes.instance
                          .push(widget: const EditProfile(), context: context);
                    },
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Routes.instance
                        .push(widget: const OrderScreen(), context: context);
                  },
                  leading: const Icon(Icons.shopping_bag_outlined),
                  title: const Text("Đơn hàng của bạn"),
                ),
                ListTile(
                  onTap: () {
                    Routes.instance.push(
                        widget: const FavouriteScreen(), context: context);
                  },
                  leading: const Icon(Icons.favorite_outline),
                  title: const Text("Sản phẩm yêu thích"),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.info_outline),
                  title: const Text("Thông tin ứng dụng"),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.support_agent_outlined),
                  title: const Text("Hỗ trợ khách hàng"),
                ),
                ListTile(
                  onTap: () {
                    Routes.instance
                        .push(widget: const ChangePassword(), context: context);
                  },
                  leading: const Icon(Icons.change_circle_outlined),
                  title: const Text("Đổi mật khẩu"),
                ),
                ListTile(
                  onTap: () {
                    FirebaseAuthHelper.instance.signOut();
                    setState(() {});
                  },
                  leading: const Icon(Icons.logout),
                  title: const Text("Đăng xuất"),
                ),
                const SizedBox(height: 12),
                const Text("Version 4.0.0")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
