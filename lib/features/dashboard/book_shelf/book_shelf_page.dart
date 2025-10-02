import 'package:flutter/material.dart';
import 'package:library_management/constants/app_colors.dart';
import 'package:library_management/features/dashboard/book_shelf/components/borrow_book_history_page.dart';
import 'package:library_management/features/dashboard/book_shelf/components/my_book_shelf_page.dart';
import 'package:library_management/model/user.dart';
import 'package:library_management/service/local_storage_service.dart';

class BookShelfPage extends StatefulWidget {
  const BookShelfPage({super.key});

  @override
  State<BookShelfPage> createState() => _BookShelfPageState();
}

class _BookShelfPageState extends State<BookShelfPage> {
  User? _user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _user = await LocalStorageService().getUser();
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: _user?.role == 'librarian'
            ? BorrowBookHistoryPage()
            : MyBookShelfPage(),
      ),
    );
  }
}
