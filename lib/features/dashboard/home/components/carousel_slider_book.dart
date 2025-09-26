import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:library_management/common/gap.dart';
import 'package:library_management/features/common/book_detail_page.dart';
import 'package:library_management/model/book.dart';

class CarouselSliderBook extends StatefulWidget {
  const CarouselSliderBook({super.key, required this.theMostBorrowedBooks});

  final List<Book> theMostBorrowedBooks;

  @override
  State<CarouselSliderBook> createState() => _CarouselSliderBookState();
}

class _CarouselSliderBookState extends State<CarouselSliderBook> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final authors = (widget.theMostBorrowedBooks[_currentIndex].authors ?? [])
        .map((e) => e.name)
        .toList()
        .join(', ');

    return Stack(
      children: [
        Center(
          child: Container(
            height: 300,
            width: width * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
              color: Colors.white,
            ),
            child: Center(
              child: Column(
                children: [
                  Gap.h20,
                  Text(
                    'BASED ON THE MOST BORROWED BOOKS',
                    style: TextStyle(fontSize: 12),
                  ),
                  Gap.h10,
                  Text(
                    widget.theMostBorrowedBooks[_currentIndex].title ?? '',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Gap.h10,
                  Text(authors, style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 160),
          child: CarouselSlider(
            options: CarouselOptions(
              height: 350,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              aspectRatio: 16 / 9,
              viewportFraction: 0.6,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              onPageChanged: (index, _) {
                _currentIndex = index;
                setState(() {});
              },
            ),
            items: widget.theMostBorrowedBooks.map((book) {
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailPage(book: book),
                        ),
                      );
                    },
                    child: Image.network(
                      book.imageUrl ?? "",
                      width: width * 0.6,
                      height: 200,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
