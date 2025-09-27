import 'package:flutter/material.dart';
import 'package:library_management/common/gap.dart';
import 'package:library_management/features/dashboard/book_shelf/components/my_book_item.dart';
import 'package:library_management/model/borrow_record.dart';
import 'package:library_management/model/user.dart';
import 'package:library_management/service/local_storage_service.dart';
import 'package:library_management/service/mongo_service.dart';

class MyBookShelfPage extends StatefulWidget {
  const MyBookShelfPage({super.key});

  @override
  State<MyBookShelfPage> createState() => _BookShelfPageState();
}

class _BookShelfPageState extends State<MyBookShelfPage> {
  late MongoService mongo;
  var borrowRecords = <BorrowRecord>[];
  User? _user;

  @override
  void initState() {
    super.initState();
    mongo = MongoService();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _user = await LocalStorageService().getUser();
      var borrowRecordList = await mongo.getBorrowRecords(userId: _user?.id);
      borrowRecords = [...borrowRecordList];
      setState(() {});
    });
  }

  Future<void> _loadData() async {
    var borrowRecordList = await mongo.getBorrowRecords(userId: _user?.id);
    setState(() {
      borrowRecords = [...borrowRecordList];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            _loadData();
          },
          child: Text(
            'My Book Shelf'.toUpperCase(),
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
        Gap.h20,
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(53),
                topRight: Radius.circular(53),
              ),
            ),
            child: Column(
              children: [
                Gap.h40,
                Expanded(
                  child: borrowRecords.isEmpty
                      ? Center(
                          child: Text('Let\'s borrow some interesting books.'),
                        )
                      : RefreshIndicator(
                          onRefresh: () => _loadData(),
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(bottom: 30),
                            itemBuilder: (context, index) {
                              final borrowRecord = borrowRecords[index];

                              return MyBookItem(
                                borrowRecord: borrowRecord,
                                onReturnBook: () {
                                  borrowOrReturnBook(borrowRecord).whenComplete(
                                    () {
                                      _loadData();
                                    },
                                  );
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider();
                            },
                            itemCount: borrowRecords.length,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> borrowOrReturnBook(BorrowRecord borrowRecord) async {
    final borrowRecordId = borrowRecord.id;
    final bookId = borrowRecord.book?.id;

    if (borrowRecordId != null && bookId != null) {
      mongo.returnBook(borrowRecordId, bookId);
    }
  }
}
