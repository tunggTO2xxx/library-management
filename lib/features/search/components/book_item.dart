import 'package:flutter/material.dart';
import 'package:library_management/common/gap.dart';
import 'package:library_management/features/common/book_detail_page.dart';
import 'package:library_management/model/book.dart';

class BookItem extends StatelessWidget {
  const BookItem({required this.book, this.onRefresh, super.key});

  final Book book;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final authors = (book.authors ?? []).map((e) => e.name).toList().join(', ');

    return GestureDetector(
      onTap: () async {
        final res = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookDetailPage(book: book)),
        );

        if (res case true) {
          onRefresh?.call();
        }
      },
      child: Row(
        children: [
          Image.network(
            book.imageUrl ?? "",
            width: 130,
            height: 180,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image),
          ),
          Gap.w10,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title ?? '',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Gap.h4,
                Text(authors, style: TextStyle(fontSize: 14)),
                Gap.h4,
                Text(
                  book.description ?? '',
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
