import 'package:flutter/material.dart';
import 'package:library_management/common/common_app_bar.dart';
import 'package:library_management/common/common_dropdown.dart';
import 'package:library_management/common/common_text_field.dart';
import 'package:library_management/common/gap.dart';
import 'package:library_management/constants/app_colors.dart';
import 'package:library_management/features/search/components/book_item.dart';
import 'package:library_management/features/user/admin/book_addition_information.dart';
import 'package:library_management/model/book.dart';
import 'package:library_management/model/user.dart';
import 'package:library_management/service/local_storage_service.dart';
import 'package:library_management/service/mongo_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late MongoService mongo;
  final _searchController = TextEditingController();
  final _fromPublishedYear = TextEditingController();
  final _toPublishedYear = TextEditingController();
  String? _selectedPublishedYear = "All";
  List<Book> books = <Book>[];
  List<String> publishedYear = <String>[];
  User? _user;

  @override
  void initState() {
    super.initState();
    mongo = MongoService();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      books = await mongo.getBooks();
      var publishedYearDB = await mongo.getPublishedYears();
      publishedYear = ["All", ...publishedYearDB, "Years"];
      _user = await LocalStorageService().getUser();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        height: 45,
        color: AppColors.bgColor,
        iconColor: Colors.white,
        actions: [
          _user?.role == 'librarian'
              ? GestureDetector(
                  onTap: () async {
                    final res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookAdditionInformation(),
                      ),
                    );

                    if (res case true) {
                      books = await mongo.getBooks();
                      setState(() {});
                    }
                  },
                  child: Icon(Icons.add, color: Colors.white),
                )
              : SizedBox(),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextField(
                controller: _searchController,
                height: 54,
                borderRadius: BorderRadius.circular(60),
                label: '',
                borderColor: Colors.white,
                fillColor: AppColors.mainColorYellow,
                hintText: 'Search',
                colorHintText: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 20),
                onChanged: (queryText) async {
                  books = await mongo.searchBooks(
                    queryText: queryText,
                    selectedYear: _selectedPublishedYear,
                    fromYear: _fromPublishedYear.text,
                    toYear: _toPublishedYear.text,
                  );
                  setState(() {});
                },
              ),
              Gap.h10,
              Row(
                children: [
                  Text('Published Year:'),
                  Gap.w10,
                  CommonDropdown(
                    width: 100,
                    height: 30,
                    items: publishedYear,
                    value: _selectedPublishedYear,
                    itemLabel: (year) {
                      return year;
                    },
                    onChanged: (value) async {
                      _selectedPublishedYear = value;

                      if (value != 'Years') {
                        books = await mongo.searchBooks(
                          queryText: _searchController.text,
                          selectedYear: _selectedPublishedYear,
                          fromYear: _fromPublishedYear.text,
                          toYear: _toPublishedYear.text,
                        );
                      }

                      setState(() {});
                    },
                  ),
                ],
              ),

              if (_selectedPublishedYear == 'Years') ...[
                Column(
                  children: [
                    Gap.h10,
                    Row(
                      children: [
                        Text('From'),
                        Gap.w10,
                        CommonTextField(
                          controller: _fromPublishedYear,
                          borderColor: Colors.black,
                          fillColor: Colors.transparent,
                          width: 100,
                          height: 30,
                          maxLength: 4,
                          textStyle: TextStyle(fontSize: 14),
                          keyboardType: TextInputType.number,
                        ),
                        Gap.w10,
                        Text('To'),
                        Gap.w10,
                        CommonTextField(
                          controller: _toPublishedYear,
                          borderColor: Colors.black,
                          fillColor: Colors.transparent,
                          width: 100,
                          height: 30,
                          maxLength: 4,
                          textStyle: TextStyle(fontSize: 14),
                          keyboardType: TextInputType.number,
                        ),
                        Gap.w10,
                        GestureDetector(
                          onTap: () async {
                            books = await mongo.searchBooks(
                              queryText: _searchController.text,
                              selectedYear: null,
                              fromYear: _fromPublishedYear.text,
                              toYear: _toPublishedYear.text,
                            );
                            setState(() {});
                          },
                          child: Icon(Icons.search),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
              Gap.h20,
              Expanded(
                child: books.isEmpty
                    ? Center(child: Text('No data found'))
                    : ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final book = books
                              .where((element) => !(element.isDelete ?? false))
                              .toList()[index];

                          return BookItem(
                            book: book,
                            onRefresh: () async {
                              books = await mongo.getBooks();
                              setState(() {});
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                        itemCount: books
                            .where((element) => !(element.isDelete ?? false))
                            .length,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
