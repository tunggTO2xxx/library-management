import 'package:flutter/material.dart';
import 'package:library_management/common/common_button.dart';
import 'package:library_management/common/common_text_field.dart';
import 'package:library_management/common/gap.dart';
import 'package:library_management/service/mongo_service.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  late MongoService mongo;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    mongo = MongoService();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _signIn({VoidCallback? onComplete}) async {
    try {
      await mongo.createUser(
        username: _usernameController.text,
        passwordHash: _passwordController.text,
        email: _emailController.text,
        fullName: _fullNameController.text,
      );

      onComplete?.call();
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
                  controller: _fullNameController,
                  label: 'Fullname',
                  labelStyle: TextStyle(color: Colors.white),
                  borderColor: Colors.black,
                  fillColor: Colors.white,
                  hintText: 'Please enter full name',
                  colorHintText: Colors.grey.shade500,
                ),
                Gap.h10,
                CommonTextField(
                  controller: _emailController,
                  label: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                  borderColor: Colors.black,
                  fillColor: Colors.white,
                  hintText: 'Please enter email',
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
                Gap.h10,
                CommonTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  labelStyle: TextStyle(color: Colors.white),
                  borderColor: Colors.black,
                  fillColor: Colors.white,
                  hintText: 'Please enter confirm password',
                  colorHintText: Colors.grey.shade500,
                  isObscure: true,
                ),
                Gap.h30,
                CommonButton(
                  textButton: 'Create account',
                  onPress: () {
                    _signIn(
                      onComplete: () {
                        Navigator.of(context).pop();
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
