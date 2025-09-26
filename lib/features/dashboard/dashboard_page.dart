import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:library_management/features/dashboard/account/account_page.dart';
import 'package:library_management/features/dashboard/book_shelf/book_shelf_page.dart';
import 'package:library_management/features/dashboard/home/home_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  // List of all main pages in your dashboard
  final List<Widget> _pages = [HomePage(), BookShelfPage(), AccountPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
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
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/ic_logo.svg',
              width: 34,
              height: 34,
              color: _selectedIndex == 0 ? Color(0xFFA28D4F) : Colors.black,
            ),
            label: "",
          ),

          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/ic_book_shelf.svg',
              width: 34,
              height: 34,
              color: _selectedIndex == 1 ? Color(0xFFA28D4F) : Colors.black,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/ic_user.svg',
              width: 34,
              height: 34,
              color: _selectedIndex == 2 ? Color(0xFFA28D4F) : Colors.black,
            ),
            label: "",
          ),
        ],
      ),
    );
  }
}
