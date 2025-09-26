import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:library_management/common/common_button.dart';
import 'package:library_management/common/gap.dart';
import 'package:library_management/constants/app_colors.dart';
import 'package:library_management/features/login/start_page.dart';
import 'package:library_management/model/user.dart';
import 'package:library_management/service/local_storage_service.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  User? _user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _user = await LocalStorageService().getUser();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Gap.h75,
            SvgPicture.asset('assets/icons/ic_logo.svg'),
            Gap.h40,
            _itemInfo(title: 'Fullname: ', info: _user?.fullName ?? ''),
            Gap.h20,
            _itemInfo(title: 'Email: ', info: _user?.email ?? ''),
            Gap.h20,
            _itemInfo(title: 'Role: ', info: _user?.role ?? ''),
            Gap.h60,
            CommonButton(
              height: 62,
              width: width * 0.7,
              textButton: 'Logout',
              onPress: _logout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemInfo({required String title, required String info}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, color: AppColors.mainColorYellow),
          ),
          Gap.w4,
          Text(
            info,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    await LocalStorageService().clearUser();

    if (!mounted) return;

    Navigator.of(context).popUntil((route) => route.isFirst);

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StartPage()),
    );
  }
}
