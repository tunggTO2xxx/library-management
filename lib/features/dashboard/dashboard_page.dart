import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:library_management/features/dashboard/account/account_page.dart';
import 'package:library_management/features/dashboard/book_shelf/book_shelf_page.dart';
import 'package:library_management/features/dashboard/home/home_page.dart';
import 'package:library_management/features/dashboard/statistic/statistic_page.dart';
import 'package:library_management/model/user.dart';
import 'package:library_management/service/local_storage_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  User? _user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _user = await LocalStorageService().getUser();
      setState(() {});
    });
  }

  final List<Widget> _readerDashboard = [
    HomePage(),
    BookShelfPage(),
    AccountPage(),
  ];

  final List<Widget> _librarianDashboard = [
    HomePage(),
    StatisticPage(),
    BookShelfPage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final isReader = _user?.role == 'reader';

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: isReader ? _readerDashboard : _librarianDashboard,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Color(0xFFD9D9D9),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: isReader
            ? [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/ic_logo.svg',
                    width: 34,
                    height: 34,
                    color: _selectedIndex == 0
                        ? Color(0xFFA28D4F)
                        : Colors.black,
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/ic_book_shelf.svg',
                    width: 34,
                    height: 34,
                    color: _selectedIndex == 1
                        ? Color(0xFFA28D4F)
                        : Colors.black,
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/ic_user.svg',
                    width: 34,
                    height: 34,
                    color: _selectedIndex == 2
                        ? Color(0xFFA28D4F)
                        : Colors.black,
                  ),
                  label: "",
                ),
              ]
            : [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/ic_logo.svg',
                    width: 34,
                    height: 34,
                    color: _selectedIndex == 0
                        ? Color(0xFFA28D4F)
                        : Colors.black,
                  ),
                  label: "",
                ),

                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/ic_statistics.svg',
                    width: 40,
                    height: 40,
                    color: _selectedIndex == 1
                        ? Color(0xFFA28D4F)
                        : Colors.black,
                  ),
                  label: "",
                ),

                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/ic_book_shelf.svg',
                    width: 34,
                    height: 34,
                    color: _selectedIndex == 2
                        ? Color(0xFFA28D4F)
                        : Colors.black,
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/ic_user.svg',
                    width: 34,
                    height: 34,
                    color: _selectedIndex == 3
                        ? Color(0xFFA28D4F)
                        : Colors.black,
                  ),
                  label: "",
                ),
              ],
      ),
    );
  }
}
