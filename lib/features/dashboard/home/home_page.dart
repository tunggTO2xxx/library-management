import 'package:flutter/material.dart';
import 'package:library_management/common/gap.dart';
import 'package:library_management/constants/app_colors.dart';
import 'package:library_management/features/dashboard/home/components/carousel_slider_book.dart';
import 'package:library_management/features/search/search_page.dart';
import 'package:library_management/model/book.dart';
import 'package:library_management/model/user.dart';
import 'package:library_management/service/local_storage_service.dart';
import 'package:library_management/service/mongo_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late MongoService mongo;
  User? _user;
  var _theMostBorrowedBooks = <Book>[];

  @override
  void initState() {
    super.initState();
    mongo = MongoService();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _user = await LocalStorageService().getUser();
      final theMostBorrowedBook = await mongo.getBookSortByTheMostBorrowed();
      _theMostBorrowedBooks = [...theMostBorrowedBook];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Gap.h30,
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Welcome Back, ',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    TextSpan(
                      text: _user?.fullName,
                      style: TextStyle(
                        color: AppColors.mainColorYellow,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              Gap.h20,
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(60),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Search',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Icon(Icons.search, color: Colors.white),
                    ],
                  ),
                ),
              ),
              Gap.h50,
              _theMostBorrowedBooks.isEmpty
                  ? SizedBox()
                  : CarouselSliderBook(
                      theMostBorrowedBooks: _theMostBorrowedBooks
                          .where((element) => !(element.isDelete ?? false))
                          .take(5)
                          .toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
