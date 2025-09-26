import 'package:flutter/material.dart';
import 'package:library_management/common/common_button.dart';
import 'package:library_management/common/common_text_field.dart';
import 'package:library_management/common/gap.dart';
import 'package:library_management/features/dashboard/dashboard_page.dart';
import 'package:library_management/service/local_storage_service.dart';
import 'package:library_management/service/mongo_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late MongoService mongo;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    mongo = MongoService();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login({VoidCallback? onComplete}) async {
    try {
      final user = await mongo.login(
        _usernameController.text,
        _passwordController.text,
      );

      if (user != null) {
        await LocalStorageService().saveUser(user);

        onComplete?.call();
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Gap.h20,
                CommonTextField(
                  controller: _usernameController,
                  label: 'Username',
                  labelStyle: TextStyle(color: Colors.white),
                  borderColor: Colors.black,
                  fillColor: Colors.white,
                  hintText: 'Please enter username',
                  colorHintText: Colors.grey.shade500,
                ),
                Gap.h10,
                CommonTextField(
                  controller: _passwordController,
                  label: 'Password',
                  labelStyle: TextStyle(color: Colors.white),
                  borderColor: Colors.black,
                  fillColor: Colors.white,
                  hintText: 'Please enter password',
                  colorHintText: Colors.grey.shade500,
                  isObscure: true,
                ),
                Gap.h30,
                CommonButton(
                  textButton: 'Login',
                  onPress: () {
                    _login(
                      onComplete: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DashboardPage(),
                          ),
                        );
                      },
                    );
                  },
                  height: 62,
                  width: width * 0.7,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
