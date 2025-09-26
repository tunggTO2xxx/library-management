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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'My Book Shelf'.toUpperCase(),
          style: TextStyle(fontSize: 24, color: Colors.white),
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
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(bottom: 30),
                    itemBuilder: (context, index) {
                      final borrowRecord = borrowRecords[index];

                      return MyBookItem(borrowRecord: borrowRecord);
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: borrowRecords.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
