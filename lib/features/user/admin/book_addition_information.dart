import 'package:flutter/material.dart';
import 'package:library_management/common/common_app_bar.dart';
import 'package:library_management/common/common_button.dart';
import 'package:library_management/common/common_dropdown.dart';
import 'package:library_management/common/common_text_field.dart';
import 'package:library_management/common/gap.dart';
import 'package:library_management/constants/app_colors.dart';
import 'package:library_management/model/author.dart';
import 'package:library_management/model/book.dart';
import 'package:library_management/model/category.dart';
import 'package:library_management/service/mongo_service.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class BookAdditionInformation extends StatefulWidget {
  const BookAdditionInformation({super.key, this.book});

  final Book? book;

  @override
  State<BookAdditionInformation> createState() =>
      _BookAdditionInformationState();
}

class _BookAdditionInformationState extends State<BookAdditionInformation> {
  late MongoService mongo;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _publishedYearController = TextEditingController();
  final _totalCopiesController = TextEditingController();
  final _locationController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _newAuthorController = TextEditingController();
  final _newCategoryController = TextEditingController();
  var authors = <Author>[];
  var categories = <Category>[];
  Author? _selectedAuthor;
  List<Category>? _selectedCategories;

  @override
  void initState() {
    super.initState();
    mongo = MongoService();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authorList = await mongo.getAuthors();
      final categoryList = await mongo.getCategories();

      authors = [...authorList, Author(name: 'Others')];
      categories = [...categoryList, Category(name: 'Others')];

      if (widget.book != null) {
        _nameController.text = widget.book?.title ?? '';
        _descriptionController.text = widget.book?.description ?? '';
        _publishedYearController.text = (widget.book?.publishedYear ?? 0)
            .toString();
        _totalCopiesController.text = (widget.book?.totalCopies ?? 0)
            .toString();
        _locationController.text = widget.book?.location ?? '';
        _imageUrlController.text = widget.book?.imageUrl ?? '';
        _selectedAuthor = authorList.firstWhereOrNull(
          (element) => element.id == widget.book?.authorIds?.first,
        );

        _selectedCategories = categories
            .where((cate) => (widget.book?.categoryIds ?? []).contains(cate.id))
            .toList();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _nameController.dispose();
    _publishedYearController.dispose();
    _totalCopiesController.dispose();
    _locationController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        height: 45,
        title: Center(
          child: Text(
            widget.book != null ? 'Update Book' : 'New Book',
            style: TextStyle(color: Colors.white),
          ),
        ),
        color: AppColors.bgColor,
        iconColor: Colors.white,
        actions: [Icon(Icons.add, color: Colors.transparent)],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Gap.h20,
                    CommonTextField(
                      controller: _nameController,
                      label: 'Name',
                      borderColor: Colors.black,
                      fillColor: Colors.transparent,
                      hintText: 'Please enter name',
                      colorHintText: Colors.grey.shade500,
                    ),
                    Gap.h10,
                    CommonTextField(
                      controller: _descriptionController,
                      label: 'Description',
                      borderColor: Colors.black,
                      fillColor: Colors.transparent,
                      hintText: 'Please enter description',
                      colorHintText: Colors.grey.shade500,
                      maxLength: null,
                    ),
                    Gap.h10,
                    CommonTextField(
                      controller: _publishedYearController,
                      label: 'Published Year',
                      borderColor: Colors.black,
                      fillColor: Colors.transparent,
                      hintText: 'Please enter published year',
                      colorHintText: Colors.grey.shade500,
                    ),
                    Gap.h10,
                    CommonDropdown<Author>(
                      label: 'Author',
                      items: authors,
                      itemLabel: (author) {
                        return author.name ?? '';
                      },
                      height: 42,
                      value: _selectedAuthor,
                      onChanged: (value) {
                        _selectedAuthor = value;
                        setState(() {});
                      },
                    ),
                    Gap.h10,
                    if (_selectedAuthor?.name == 'Others') ...[
                      CommonTextField(
                        controller: _newAuthorController,
                        label: 'Author',
                        borderColor: Colors.black,
                        fillColor: Colors.transparent,
                        hintText: 'Please enter author',
                        colorHintText: Colors.grey.shade500,
                      ),
                      Gap.h10,
                    ],

                    CommonDropdown<Category>(
                      label: 'Category',
                      disableMultipleSelect: false,
                      items: categories,
                      itemLabel: (category) {
                        return category.name ?? '';
                      },
                      height: 42,
                      selectedItems: _selectedCategories,
                      onChangedMultiSelect: (value) {
                        _selectedCategories = value;
                        setState(() {});
                      },
                      onChanged: (_) {},
                    ),
                    Gap.h10,
                    if ((_selectedCategories ?? []).isNotEmpty &&
                        _selectedCategories?.first.name == 'Others') ...[
                      CommonTextField(
                        controller: _newCategoryController,
                        label: 'Category',
                        borderColor: Colors.black,
                        fillColor: Colors.transparent,
                        hintText: 'Please enter category',
                        colorHintText: Colors.grey.shade500,
                      ),
                      Gap.h10,
                    ],
                    CommonTextField(
                      controller: _totalCopiesController,
                      label: 'Total Copies',
                      borderColor: Colors.black,
                      fillColor: Colors.transparent,
                      hintText: 'Please enter total copies',
                      colorHintText: Colors.grey.shade500,
                    ),
                    Gap.h10,
                    CommonTextField(
                      controller: _locationController,
                      label: 'Location',
                      borderColor: Colors.black,
                      fillColor: Colors.transparent,
                      hintText: 'Please enter location',
                      colorHintText: Colors.grey.shade500,
                    ),
                    Gap.h10,
                    CommonTextField(
                      controller: _imageUrlController,
                      label: 'Image Url',
                      borderColor: Colors.black,
                      fillColor: Colors.transparent,
                      hintText: 'Please enter image url',
                      colorHintText: Colors.grey.shade500,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CommonButton(
                textButton: widget.book != null
                    ? 'Update your book'
                    : 'Add your new book',
                height: 48,
                colorButton: AppColors.mainColorYellow,
                onPress: () {
                  _addOrUpdateNewBook(
                    onComplete: () {
                      if (widget.book != null) {
                        const snackBar = SnackBar(
                          content: Text('Update your book completely'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop(true);
                        return;
                      }

                      const snackBar = SnackBar(
                        content: Text('Add new book completely'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.of(context).pop(true);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addOrUpdateNewBook({required VoidCallback onComplete}) async {
    await mongo.addOrUpdateNewBook(
      title: _nameController.text,
      description: _descriptionController.text,
      publishedYear: int.tryParse(_publishedYearController.text) ?? 0,
      totalCopies: int.tryParse(_totalCopiesController.text) ?? 0,
      location: _locationController.text,
      imageUrl: _imageUrlController.text,
      selectedAuthor: _selectedAuthor ?? Author(),
      selectedCategories: _selectedCategories ?? [],
      authorInput: _newAuthorController.text,
      categoryInput: _newCategoryController.text,
      book: widget.book,
    );

    onComplete.call();
  }
}
