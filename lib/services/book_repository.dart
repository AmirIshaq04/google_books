import 'package:book_finder_flutter/models/book_data.dart';
import 'package:dio/dio.dart';

class BookRepository {
  final Dio _dio = Dio();

  Future<BookData> fetchBooks(String query) async {
    try {
      final response = await _dio.get(
        "https://www.googleapis.com/books/v1/volumes?q=$query",
      );
      if (response.statusCode == 200) {
        return BookData.fromJson(response.data);
      } else {
        throw Exception("Failed to fetch books${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to fetch books: $e");
    }
  }
}
