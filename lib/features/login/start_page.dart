import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:library_management/common/common_button.dart';
import 'package:library_management/common/gap.dart';
import 'package:library_management/features/dashboard/dashboard_page.dart';
import 'package:library_management/features/login/login/login_page.dart';
import 'package:library_management/features/login/signin/signin_page.dart';
import 'package:library_management/service/local_storage_service.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = await LocalStorageService().getUser();

      if (user != null) {
        if (!mounted) return;
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      }
    });
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
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 150),
                  child: SvgPicture.asset('assets/icons/ic_logo.svg'),
                ),
              ),
              Align(
                child: Column(
                  children: [
                    CommonButton(
                      textButton: 'Login',
                      onPress: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      height: 62,
                      width: width * 0.7,
                    ),
                    Gap.h15,
                    CommonButton(
                      textButton: 'Create Account',
                      onPress: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SigninPage()),
                        );
                      },
                      height: 62,
                      width: width * 0.7,
                      colorButton: Color(0xFFA28D4F),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
