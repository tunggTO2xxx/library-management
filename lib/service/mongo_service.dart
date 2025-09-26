import 'package:library_management/model/author.dart';
import 'package:library_management/model/book.dart';
import 'package:library_management/model/borrow_record.dart';
import 'package:library_management/model/category.dart';
import 'package:library_management/model/user.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoService {
  static final MongoService _instance = MongoService._internal();
  factory MongoService() => _instance;

  MongoService._internal();

  late Db db;
  late DbCollection users;
  late DbCollection books;
  late DbCollection authors;
  late DbCollection categories;
  late DbCollection borrowRecords;

  Future<void> connect() async {
    db = await Db.create("mongodb://localhost:27017/library");
    await db.open();
    users = db.collection("Users");
    books = db.collection('Books');
    authors = db.collection('Authors');
    categories = db.collection('Categories');
    borrowRecords = db.collection('BorrowRecords');
  }

  Future<User?> login(String username, String passwordHash) async {
    final result = await users.findOne({
      "username": username,
      "password_hash": passwordHash,
    });

    if (result != null) {
      return User.fromJson(result);
    }
    return null;
  }

  /// Lấy list cuốn sách và tham chiếu sang các collection Author và Categoriry
  Future<List<Book>> getBooks() async {
    final pipeline = [
      {
        r'$lookup': {
          'from': 'Authors',
          'localField': 'author_ids',
          'foreignField': '_id',
          'as': 'authors',
        },
      },
      {
        r'$lookup': {
          'from': 'Categories',
          'localField': 'category_ids',
          'foreignField': '_id',
          'as': 'categories',
        },
      },
    ];

    final bookList = await books.aggregateToStream(pipeline).toList();
    return bookList.map((json) => Book.fromJson(json)).toList();
  }

  Future<List<Book>> getBookSortByTheMostBorrowed() async {
    final pipeline = [
      {
        r'$addFields': {
          'borrowed_count': {
            r'$subtract': [r'$total_copies', r'$available_copies'],
          },
        },
      },
      {
        r'$lookup': {
          'from': 'Authors',
          'localField': 'author_ids',
          'foreignField': '_id',
          'as': 'authors',
        },
      },
      {
        r'$lookup': {
          'from': 'Categories',
          'localField': 'category_ids',
          'foreignField': '_id',
          'as': 'categories',
        },
      },
      {
        r'$sort': {'borrowed_count': -1},
      },
    ];

    final bookList = await books.aggregateToStream(pipeline).toList();
    return bookList.map((json) => Book.fromJson(json)).toList();
  }

  /// Lấy được list các cuốn sách mà có ít nhất 1 tag trùng với cuốn sách có id truyền vào
  Future<List<Book>> getRelatedTagBook(String id) async {
    final bookId = ObjectId.parse(id);

    final pipeline = [
      {
        r'$match': {'_id': bookId},
      },
      {
        r'$project': {'tags': 1},
      },
      {
        r'$lookup': {
          'from': 'Books',
          'let': {'tagsOfTarget': r'$tags'},
          'pipeline': [
            {
              r'$match': {
                r'$expr': {
                  r'$gt': [
                    {
                      r'$size': {
                        r'$setIntersection': [r'$tags', r'$$tagsOfTarget'],
                      },
                    },
                    0,
                  ],
                },
              },
            },
            {
              r'$lookup': {
                'from': 'Authors',
                'localField': 'author_ids',
                'foreignField': '_id',
                'as': 'authors',
              },
            },
            {
              r'$lookup': {
                'from': 'Categories',
                'localField': 'category_ids',
                'foreignField': '_id',
                'as': 'categories',
              },
            },
          ],
          'as': 'relatedBooks',
        },
      },
      {r'$unwind': r'$relatedBooks'},
      {
        r'$replaceRoot': {'newRoot': r'$relatedBooks'},
      },
    ];

    final bookList = await books.aggregateToStream(pipeline).toList();
    return bookList.map((json) => Book.fromJson(json)).toList();
  }

  Future<List<Author>> getAuthors() async {
    final authorList = await authors.find().toList();

    return authorList.map((e) => Author.fromJson(e)).toList();
  }

  Future<List<Category>> getCategories() async {
    final categoryList = await categories.find().toList();

    return categoryList.map((e) => Category.fromJson(e)).toList();
  }

  Future<void> addOrUpdateNewBook({
    required String title,
    required String description,
    required int publishedYear,
    required int totalCopies,
    required String location,
    required String imageUrl,
    required Author selectedAuthor,
    String? authorInput,
    required List<Category> selectedCategories,
    String? categoryInput,
    Book? book,
  }) async {
    final now = DateTime.now();

    // ---- 1. Handle Author ----
    ObjectId authorId;
    if (selectedAuthor.name == 'Others') {
      final newAuthor = Author(name: authorInput, createdAt: now);
      final insertedAuthor = await authors.insertOne(newAuthor.toJson());
      authorId = ObjectId.tryParse(insertedAuthor.id.toString()) ?? ObjectId();
    } else {
      authorId = ObjectId.tryParse(selectedAuthor.id.toString()) ?? ObjectId();
    }

    // ---- 2. Handle Categories ----
    List<ObjectId> categoryIds = [];
    List<String> tags = [];

    for (var category in selectedCategories) {
      if (category.name == 'Others') {
        final newCategory = Category(
          name: categoryInput,
          slug: (categoryInput ?? '').toLowerCase(),
        );

        final insertedCategory = await categories.insertOne(
          newCategory.toJson(),
        );
        final newId =
            ObjectId.tryParse(insertedCategory.id.toString()) ?? ObjectId();
        categoryIds.add(newId);
        tags.add((categoryInput ?? '').toLowerCase());
      } else {
        categoryIds.add(
          ObjectId.tryParse(category.id.toString()) ?? ObjectId(),
        );
        tags.add((category.slug ?? '').toLowerCase());
      }
    }

    // ---- 3. Insert Book ----
    final newBook = Book(
      title: title,
      description: description,
      publishedYear: publishedYear,
      authorIds: [authorId.toHexString()],
      categoryIds: categoryIds.map((e) => e.toHexString()).toList(),
      tags: tags,
      location: location,
      totalCopies: totalCopies,
      availableCopies: book != null ? null : totalCopies,
      imageUrl: imageUrl,
      createdAt: book != null ? null : now,
      updatedAt: now,
    );

    if (book != null) {
      if (book.id == null) return;
      updateBook(book.id!, newBook);
      return;
    }

    await books.insertOne(newBook.toJson());
  }

  Future<void> updateBook(String id, Book book) async {
    final bookId = ObjectId.fromHexString(id);

    final updateDoc = book.toJson();

    await books.updateOne(where.id(bookId), {r'$set': updateDoc});
  }

  Future<List<Book>> searchBooks({
    String? queryText,
    String? selectedYear,
    String? fromYear,
    String? toYear,
  }) async {
    final pipeline = <Map<String, Object>>[
      {
        r'$lookup': {
          'from': 'Authors',
          'localField': 'author_ids',
          'foreignField': '_id',
          'as': 'authors',
        },
      },
      {
        r'$lookup': {
          'from': 'Categories',
          'localField': 'category_ids',
          'foreignField': '_id',
          'as': 'categories',
        },
      },
    ];

    if (queryText != null && queryText.isNotEmpty) {
      pipeline.add({
        r'$match': {
          r'$or': [
            {
              'title': {r'$regex': queryText, r'$options': 'i'},
            },
            {
              'description': {r'$regex': queryText, r'$options': 'i'},
            },
            {
              'authors.name': {r'$regex': queryText, r'$options': 'i'},
            },
            {
              'tags': {r'$regex': queryText, r'$options': 'i'},
            },
          ],
        },
      });
    }

    if (selectedYear != null && selectedYear.isNotEmpty) {
      final year = int.tryParse(selectedYear);
      if (year != null) {
        pipeline.add({
          r'$match': {'published_year': year},
        });
      }
    }

    // Search theo khoảng năm
    if ((fromYear != null && fromYear.isNotEmpty) ||
        (toYear != null && toYear.isNotEmpty)) {
      final match = <String, Object>{};

      final from = int.tryParse(fromYear ?? '');
      final to = int.tryParse(toYear ?? '');

      if (from != null) {
        match[r'$gte'] = from;
      }
      if (to != null) {
        match[r'$lte'] = to;
      }

      if (match.isNotEmpty) {
        pipeline.add({
          r'$match': {'published_year': match},
        });
      }
    }

    final result = await books.aggregateToStream(pipeline).toList();
    return result.map((doc) => Book.fromJson(doc)).toList();
  }

  Future<List<BorrowRecord>> getBorrowRecords({
    String? status,
    String? userId,
  }) async {
    final pipeline = [
      {
        r'$lookup': {
          'from': 'Users',
          'localField': 'user_id',
          'foreignField': '_id',
          'as': 'user',
        },
      },
      {r'$unwind': r'$user'},
      {
        r'$lookup': {
          'from': 'Books',
          'localField': 'book_id',
          'foreignField': '_id',
          'as': 'book',
        },
      },
      {r'$unwind': r'$book'},
      {
        r'$lookup': {
          'from': 'Authors',
          'localField': 'book.author_ids',
          'foreignField': '_id',
          'as': 'book.authors',
        },
      },
    ];

    if (status != null) {
      pipeline.add({
        r'$match': {'status': status},
      });
    }

    if (userId != null) {
      final id = ObjectId.fromHexString(userId);
      pipeline.add({
        r'$match': {'user_id': id},
      });
    }

    pipeline.add({
      r'$project': {
        '_id': 1,
        'user_id': 1,
        'book_id': 1,
        'borrowed_at': 1,
        'due_at': 1,
        'returned_at': 1,
        'status': 1,
        'user': {'_id': 1, 'full_name': 1, 'email': 1, 'role': 1},
        'book': {
          '_id': 1,
          'title': 1,
          'published_year': 1,
          'tags': 1,
          'image_url': 1,
          'authors': {'_id': 1, 'name': 1},
        },
      },
    });

    final result = await borrowRecords.aggregateToStream(pipeline).toList();

    return result.map((doc) => BorrowRecord.fromJson(doc)).toList();
  }

  Future<List<String>> getPublishedYears() async {
    final pipeline = [
      {
        r'$group': {'_id': r'$published_year'},
      },
      {
        r'$sort': {'_id': 1},
      },
      {
        r'$project': {
          'year': {r'$toString': r'$_id'},
          '_id': 0,
        },
      },
    ];

    final result = await books.aggregateToStream(pipeline).toList();

    return result.map((doc) => doc['year'] as String).toList();
  }
}
