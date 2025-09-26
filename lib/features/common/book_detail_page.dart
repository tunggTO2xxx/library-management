import 'package:flutter/material.dart';
import 'package:library_management/common/common_button.dart';
import 'package:library_management/common/gap.dart';
import 'package:library_management/constants/app_colors.dart';
import 'package:library_management/features/user/admin/book_addition_information.dart';
import 'package:library_management/model/book.dart';
import 'package:library_management/model/user.dart';
import 'package:library_management/service/local_storage_service.dart';
import 'package:library_management/service/mongo_service.dart';

class BookDetailPage extends StatefulWidget {
  const BookDetailPage({required this.book, super.key});

  final Book book;

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  late MongoService mongo;
  var _relatedBooks = <Book>[];
  User? _user;

  @override
  void initState() {
    super.initState();
    mongo = MongoService();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var relatedTagBooks = await mongo.getRelatedTagBook(widget.book.id ?? '');
      _relatedBooks = [...relatedTagBooks];
      _user = await LocalStorageService().getUser();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final authors = (widget.book.authors ?? [])
        .map((e) => e.name)
        .toList()
        .join(', ');
    final categories = (widget.book.categories ?? [])
        .map((e) => e.name)
        .toList()
        .join(', ');

    final tags = (widget.book.tags ?? []).map((e) => '#$e').toList().join(', ');

    return Scaffold(
      body: Stack(
        children: [
          /// Background image
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.book.imageUrl ?? ''),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// White card content
          DraggableScrollableSheet(
            initialChildSize: 0.55,
            minChildSize: 0.55,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.book.title ?? '',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Gap.w4,
                          _user?.role == 'librarian'
                              ? GestureDetector(
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BookAdditionInformation(
                                              book: widget.book,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Icon(Icons.edit),
                                )
                              : SizedBox(),
                        ],
                      ),
                      Gap.h4,
                      _buildBookDetailInfo(title: 'Author: ', content: authors),
                      Gap.h12,
                      _buildBookDetailInfo(
                        title: 'Category: ',
                        content: categories,
                      ),
                      Gap.h12,
                      _buildBookDetailInfo(
                        title: 'Published Year: ',
                        content: (widget.book.publishedYear ?? 0).toString(),
                      ),
                      Gap.h12,
                      _buildBookDetailInfo(
                        title: 'Remaining Books: ',
                        content: (widget.book.availableCopies ?? 0).toString(),
                      ),
                      Gap.h12,
                      _buildBookDetailInfo(
                        title: 'Location: ',
                        content: (widget.book.location ?? 0).toString(),
                      ),
                      Gap.h12,

                      /// Description
                      Text(
                        widget.book.description ?? '',

                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          height: 1.4,
                        ),
                      ),

                      Gap.h12,

                      Text(
                        tags,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.mainColorYellow,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// Buttons
                      CommonButton(
                        height: 48,
                        textButton: 'Get this book',
                        colorButton: AppColors.mainColorYellow,
                        onPress: () {},
                      ),

                      Gap.h20,

                      SizedBox(
                        height: 220,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Related Books:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Gap.h15,
                            Expanded(
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final relatedBook = _relatedBooks[index];

                                  return GestureDetector(
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BookDetailPage(book: relatedBook),
                                        ),
                                      );
                                    },
                                    child: Image.network(
                                      relatedBook.imageUrl ?? "",
                                      width: 130,
                                      height: 200,
                                      fit: BoxFit.fill,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.broken_image),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Gap.w10;
                                },
                                itemCount: _relatedBooks.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBookDetailInfo({
    required String title,
    required String content,
  }) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$title: ',
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
          TextSpan(
            text: content,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.mainColorYellow,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
